local jdtls_status, jdtls = pcall(require, "jdtls")
if not jdtls_status then
  vim.notify("jdts not found")
  return
end
local jdtls_dap_status, jdtls_dap = pcall(require, "jdtls.dap")
if not jdtls_dap_status then
  vim.notify("jdts dap not found")
  return
end
lvim.lsp.on_attach_callback = function(client)
  if client.name == 'jdtls' then
    jdtls.setup_dap { hotcodereplace = "auto" }
    jdtls_dap.setup_dap_main_class_configs()
  end
end
