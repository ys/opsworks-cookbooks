node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  template "~/environment_variables.sh" do
    source "environment_variables.erb"
    cookbook 'env-vars'
    group deploy[:group]
    owner deploy[:user]
    variables(:env_vars => deploy[:env_vars])

    notifies :run, resources(:execute => "restart Rails app #{application}")

    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/current/config/")
    end
  end

  script "set_my_app_shell_environment_vars" do
    interpreter "bash"
    user deploy[:user]
    code <<-EOH
      echo "source $HOME/environment_variables.sh" >> ~/.bash_profile
    EOH
  end
end
