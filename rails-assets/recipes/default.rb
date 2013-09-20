node[:deploy].each do |application, deploy|

  Chef::Log.info(" Running deploy / myapp Before_migrate.Rb in App ... ")
  current_release = release_path

  execute "rake assets: PRECOMPILE"  do
    cwd current_release
    command "bundle EXEC rake assets:PRECOMPILE"
    environment " RAILS_ENV " => 'production'
  end
end
