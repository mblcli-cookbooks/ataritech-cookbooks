include_recipe "collectd"

collectd_plugin "memcached" do
  options :host=>'eol-search2.rc.fas.harvard.edu', :port => '1121'
end
