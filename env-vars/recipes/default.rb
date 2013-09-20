node[:deploy].each do |application, deploy|
  deploy = node[:deploy][application]

  execute "restart Rails app #{application}" do
    cwd deploy[:current_path]
    command node[:opsworks][:rails_stack][:restart_command]
    action :nothing
  end

  template "/etc/environment" do
    source "environment.erb"
    cookbook 'env-vars'
    group deploy[:group]
    owner deploy[:user]
    mode 0755
    variables(:env_vars => deploy[:env_vars])

    notifies :run, resources(:execute => "restart Rails app #{application}")
  end
end
