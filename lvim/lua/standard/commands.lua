local opts = { force = true }

vim.api.nvim_create_user_command('JavaInitProject',
  ':! mvn archetype:generate -DarchetypeArtifactId:org.apache.maven.archetypes:maven-archetype-quickstart -DgroupId=com.NewProject.app -DartifactId=NewProject -DinteractiveMode=false<cr>'
  , opts)

local dap_widget_status, widgets = pcall(require, "dap.ui.widgets")

if dap_widget_status then
  local sidebar = widgets.sidebar(widgets.scopes, {
    width = 50
  })
  local sideBarToggle = function()
    sidebar.toggle()
  end

  local hoverFn = widgets.hover
  vim.api.nvim_create_user_command('DapHover', hoverFn, opts)
  vim.api.nvim_create_user_command('DapSidebarToggle', sideBarToggle, opts)
  return
end
