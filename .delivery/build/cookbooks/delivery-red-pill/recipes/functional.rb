#
# Cookbook Name:: delivery-red-pill
# Recipe:: functional
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
include_recipe 'delivery-truck::functional'

if node['delivery']['change']['pipeline'] == 'master' && node['delivery']['change']['stage'] == 'acceptance'
  delivery_change_db node['delivery']['change']['change_id'] do
    action :download
  end

  ## Monitor pipeline acceptance stages for completion.
  delivery_in_parallel do
    matrix = node['delivery-red-pill']['acceptance']['matrix']
    ## If you do not use .ech here the lazy evals get all messed up and evaluate
    ## each iteration as if it was the last.
    matrix.each do |vector|
      delivery_wait_for_stage "Wait for #{node['delivery']['change']['stage']} case #{vector}" do
        change_id lazy { node.run_state['delivery']['change']['data']['spawned_changes']["#{vector}"] }
        stage node['delivery']['change']['stage']
      end
    end
  end
elsif node['delivery']['change']['pipeline'] != 'master'
  include_recipe "delivery-red-pill::_include_build_cb_recipe"
end
