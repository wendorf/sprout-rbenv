define :ruby_install do
  ruby_version = params[:version] || params[:name]
  options = params[:options] || {}

  include_recipe "sprout-rbenv"

  rbenv_cmd = node['sprout']['rbenv']['command']
  install_cmd = "#{rbenv_cmd} install #{ruby_version} #{options[:command_line_options]}"

  execute "installing #{ruby_version} with RBENV: #{install_cmd}" do
    command install_cmd
    user params[:user] || node['sprout']['user']
    only_if params[:only_if] if params[:only_if]
    not_if params[:not_if] || "#{rbenv_cmd} versions | grep #{ruby_version}"
    env options[:env]
  end

  execute "check #{ruby_version}" do
    command "#{rbenv_cmd} versions | grep #{ruby_version}"
    user params[:user] || node['sprout']['user']
  end
end
