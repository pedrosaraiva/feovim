local dap = require('dap')
dap.adapters.go = function(callback, config)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
  local port = 38697
  local opts = {
    stdio = { nil, stdout },
    args = { "dap", "-l", "127.0.0.1:" .. port },
    detached = true
  }
  handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
    stdout:close()
    handle:close()
    if code ~= 0 then
      print('dlv exited with code', code)
    end
  end)
  assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
  stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require('dap.repl').append(chunk)
      end)
    end
  end)
  -- Wait for delve to start
  vim.defer_fn(
    function()
      callback({ type = "server", host = "127.0.0.1", port = port })
    end,
    100)
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "go",
    name = "Debug",
    request = "launch",
    program = "${file}"
  },
  {
    type = "go",
    name = "main.go",
    request = "launch",
    program = "${workspaceFolder} main.go"
  },
  {
    type = "go",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}"
  },
  -- works with go.mod packages and sub packages
  {
    type = "go",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}"
  },
}

dap.adapters.coreclr = {
  type = 'executable',
  command = 'netcoredbg',
  args = {'--interpreter=vscode'}
}

vim.g.dotnet_build_project = function()
  local default_path = vim.fn.getcwd() .. '/'
  if vim.g['dotnet_last_proj_path'] ~= nil then
      default_path = vim.g['dotnet_last_proj_path']
  end
  local path = vim.fn.input('Path to your *proj file', default_path, 'file')
  vim.g['dotnet_last_proj_path'] = path
  local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
  print('')
  print('Cmd to execute: ' .. cmd)
  local f = os.execute(cmd)
  if f == 0 then
      print('\nBuild: ✔️ ')
  else
      print('\nBuild: ❌ (code: ' .. f .. ')')
  end
end

vim.g.dotnet_get_dll_path = function()
  local request = function()
      return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
  end

  if vim.g['dotnet_last_dll_path'] == nil then
      vim.g['dotnet_last_dll_path'] = request()
  else
      if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
          vim.g['dotnet_last_dll_path'] = request()
      end
  end

  return vim.g['dotnet_last_dll_path']
end

local config = {
{
  type = "coreclr",
  name = "launch - netcoredbg",
  request = "launch",
  program = function()
      if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
          vim.g.dotnet_build_project()
      end
      return vim.g.dotnet_get_dll_path()
  end,
},
}

dap.configurations.cs = config
