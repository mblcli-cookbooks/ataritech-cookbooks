gem_package "eventmachine"

cookbook_file File.join(node[:collectd][:plugin_dir], "varnish.rb") do
  owner "nobody"
  group "nobody"
  mode "755"
end

servers = []
if node[:recipes].include? "varnish::dual-edge"
  servers << "localhost"
end


#shortcuts later..
# collectd_exec_plugin "varnish" do
#   options :host=>servers, :user=>'nobody'
# end


template "/etc/collectd/plugins/varnish.conf" do
  source "plugins/eol_varnish.conf.erb"
  owner "root"
  group "root"
  mode "644"
  notifies :restart, resources(:service => "collectd")
end