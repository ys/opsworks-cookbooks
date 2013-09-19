node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  template "#{deploy[:deploy_to]}/current/config/initializers/environment_variables.rb" do
    source "enviroment_variables.erb"
    cookbook 'env-vars'
    group deploy[:group]
    owner deploy[:user]
    variables(:env_vars => deploy[:env_vars])

    notifies :run, resources(:execute => "restart Rails app #{application}")

    only_if do
      File.exists?("#{deploy[:deploy_to]}") && File.exists?("#{deploy[:deploy_to]}/current/config/")
    end
  end
end
