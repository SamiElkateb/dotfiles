
lvim.builtin.dap.active = true
-- local dap_install = require "dap-install"
-- dap_install.config("go_delve", {})

local jdtls_status, jdtls = pcall(require, "jdtls")
if not jdtls_status then
  vim.notify("jdtls not found")
  return
end

  vim.notify("jdtls found!")
local dap_status, dap = pcall(require, "dap")
if not dap_status then
  vim.notify("dap not found")
  return
end
