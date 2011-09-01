#!/usr/bin/env ruby

require 'rubygems'
require 'eventmachine'
require 'getoptlong'

opts = GetoptLong.new(
  [ '--hostid', '-h', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--sampling-interval', '-i',  GetoptLong::OPTIONAL_ARGUMENT ]
)

def usage
  puts("#{$0} -h <host_id> [-i <sampling_interval>]")
  exit
end

sampling_interval = nil
hostname = `hostname -f`.chomp

opts.each do |opt, arg|
  case opt
    when '--hostid'
      hostname = arg
    when '--sampling-interval'
      sampling_interval = arg.to_i
  end
end

def underscore(camel_cased_word)
  camel_cased_word.to_s.gsub(/::/, '/').
  gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
  gsub(/([a-z\d])([A-Z])/,'\1_\2').
  tr("-", "_").
  tr(" ", "_").
  downcase
end

EM.run do
    EM.add_periodic_timer(sampling_interval||2) do
    now = Time.now.to_i
    stats = `varnishstat -1` 
    stats.each_line do |line|
      #client_conn            211980         0.30 Client connections accepted
      next unless /^(\w+)\s+(\d+)\s+(\d+\.\d+)\s(.+)$/.match(line)
      puts("PUTVAL #{hostname}/varnish/counter-#{underscore $4} #{now}:#{$2}")
    end
    end
end