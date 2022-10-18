local filepath = vim.api.nvim_buf_get_name(0):gsub(" ", "\\ ");


vim.api.nvim_command(':! echo ' ..filepath)
vim.api.nvim_command(':10TermExec open=0 cmd="zathura ' .. filepath .. '"')
