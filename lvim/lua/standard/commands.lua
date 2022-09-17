local options = { force = true }

-- https://github.com/nanotee/nvim-lua-guide/blob/master/README.md
-- https://maven.apache.org/guides/mini/guide-creating-archetypes.html

vim.api.nvim_create_user_command(
  'JavaInitProject',
  function(opts)
    local args = vim.split(opts.args, " ")
    local groupId = args[1]
    local artifactId = args[1]
    local MainClassName = 'App'
    if args[2] then
      artifactId = args[2]
    end

    if args[3] then
      MainClassName = args[3]
    end
    local command = 'mvn archetype:generate -DarchetypeArtifactId:org.apache.maven.archetypes:maven-archetype-quickstart:1.4 -DgroupId='
        .. groupId .. ' -DartifactId=' .. artifactId .. ' -DinteractiveMode=false'
    local properties = "\\n\\t<properties>\\n\\t\\t<maven.compiler.source>11<\\/maven.compiler.source>\\n\\t\\t<maven.compiler.target>11<\\/maven.compiler.target>\\n\\t\\t<exec.mainClass>"
        .. groupId .. "." .. MainClassName .. "<\\/exec.mainClass>\\n\\t<\\/properties>"
    local addPropertiesCommand = "sed -i '' 's/\\/url>/\\/url>" .. properties .. "/' ./pom.xml"
    local renameMainClass = ''
    if MainClassName ~= 'App' then
      renameMainClass = " && cd src/main/java/" ..
          groupId ..
          " && sed -i '' 's/App/" .. MainClassName .. "/g' App.java && mv App.java " .. MainClassName .. ".java"
    end
    vim.api.nvim_command(':!' .. command .. ' && cd ' .. artifactId .. ' && ' .. addPropertiesCommand .. renameMainClass)
  end,
  { force = true, nargs = 1 }
)

vim.api.nvim_create_user_command(
  'CBuildAndRun',
  function()
    local filepath = vim.api.nvim_buf_get_name(0)
    local dirpath = filepath:match("(.*/)")
    -- print (filepath)
    local command = 'gcc ' .. filepath
    vim.api.nvim_command(':9TermExec cmd="cd ' .. dirpath .. ' && ' .. command .. ' && ./a.out" <cr>')
  end,
  {}
)
-- vim.api.nvim_create_user_command('JavaBuildAndRun',
--   ':term cd `(find $(pwd) -name java -type d | grep main/java || echo ${$(pwd)\\%java*}java) | grep main/java` && javac **/App.java && java **/App.java <cr>'
--   , opts)

vim.api.nvim_create_user_command('JavaBuildAndRun',
  ':9TermExec cmd="mvn -q clean compile exec:java"'
  , options)



-- vim.api.nvim_set_keymap("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

local dap_widget_status, widgets = pcall(require, "dap.ui.widgets")

if dap_widget_status then
  local sidebar = widgets.sidebar(widgets.scopes, {
    width = 50
  })
  local sideBarToggle = function()
    sidebar.toggle()
  end

  local hoverFn = widgets.hover
  vim.api.nvim_create_user_command('DapHover', hoverFn, options)
  vim.api.nvim_create_user_command('DapSidebarToggle', sideBarToggle, options)
  -- return
end


local toggleterm_status, toggleterm = pcall(require, "toggleterm.terminal")
-- local Terminal  = require('toggleterm.terminal').Terminal
if toggleterm_status then
  local lazygit = toggleterm.Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
  -- function to run on closing the terminal
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})
  local function _lazygit_toggle()
    vim.notify('function called')
    lazygit:toggle()
  end
  vim.api.nvim_create_user_command('LazygitToggle', _lazygit_toggle, options)
  local status_ok, which_key = pcall(require, "which-key")
  if not status_ok then
    return
  end

  local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  }

  local mappings = {
    g = {
      name = "Git",
      t = { "<Cmd>LazygitToggle<CR>", "Lazygit" },
    },
  }
  which_key.register(mappings, opts)
end
