#
# Cookbook Name:: delivery-cluster
# Recipe:: _helper
#
# Copyright 2015, Chef Software, Inc.
#
# All rights reserved - Do Not Redistribute
#

module DeliveryCluster
  module Helper
    def current_dir
      @current_dir ||= Chef::Config.chef_repo_path
    end

    def tmp_infra_dir
      @tmp_infra_dir ||= File.join(current_dir, "infra/tmp")
    end

    def dot_chef_dir
      @dot_chef_dir ||= File.join(current_dir, '.chef')
    end

    # delivery-ctl needs to be executed with elevated privileges
    def delivery_ctl
      if node['delivery-cluster']['aws']['ssh_username'] == 'root'
        'delivery-ctl'
      else
        'sudo -E delivery-ctl'
      end
    end
  end
end

Chef::Recipe.send(:include, DeliveryCluster::Helper)
Chef::Resource.send(:include, DeliveryCluster::Helper)