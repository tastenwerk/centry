task :routes do
  require 'centry'
  Centry::API::mount_paths.each do |app|
    puts "#{app.name}"
    app.routes.each do |api|
      method = api.route_method.ljust(10)
      path = api.route_path
      puts "     #{method} #{path}"
    end
  end
end
