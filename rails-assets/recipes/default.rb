node[:deploy].each do |application, deploy|

  Chef::Log.info(" Running deploy / myapp Before_migrate.Rb in App ... ")

  execute "rake assets: PRECOMPILE"  do
    cwd "#{deploy[:deploy_to]}/current"
    command "bundle EXEC rake assets:PRECOMPILE && bundle EXEC rake assets:sync"
    environment " RAILS_ENV " => 'production'
  end
end
