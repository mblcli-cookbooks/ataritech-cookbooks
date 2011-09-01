include_recipe "collectd"

collectd_plugin "memcached" do
  options :host=>'localhost', :port => '11211'
end
