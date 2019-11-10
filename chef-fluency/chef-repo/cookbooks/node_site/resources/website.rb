property :homepage, String, default: '<h1>Hello world!</h1>'

action :create do
  folder = '/var/www/html/'
  file = 'index.html'

  
  if platform_family?("debian")
    apt_update
  end

  package 'Install Apache' do
    case node[:platform]
    when 'redhat', 'centos'
      package_name 'httpd'
      action :upgrade
    when 'ubuntu', 'debian'
      package_name 'apache2'
      action :upgrade
    end
  end

  service 'Start Apache' do
    case node[:platform]
    when 'redhat', 'centos'
      service_name 'httpd'
      action [:enable, :start]
    when 'ubuntu', 'debian'
      service_name 'apache2'
      action [:enable, :start]
    end
  end

  file "#{folder}#{file}" do
    content new_resource.homepage
  end
end

action :delete do
  package 'httpd' do
    action :delete
  end
end
