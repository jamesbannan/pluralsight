property :homepage, String, default: '<h1>Hello world!</h1>'

action :create do
  folder = "#{node['iis']['docroot']}"
  file = 'index.html'

  iis_install 'Install IIS' do
    additional_components node['iis']['components']
    source node['iis']['source']
  end

  service 'iis' do
    service_name 'W3SVC'
    action [:enable, :start]
  end

  file "#{folder}/#{file}" do
    content new_resource.homepage
  end
end

action :delete do
  service 'iis' do
    service_name 'W3SVC'
    action [:stop]
  end

  windows_feature ['IIS-WebServerRole'] do
    action :remove
  end
end
