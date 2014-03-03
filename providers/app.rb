#
# Cookbook Name:: slimta
# Provider:: slimta_app
#
# Copyright (c) 2014 Ian C. Good
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

def whyrun_supported?
  true
end

use_inline_resources

action :create do
  updated = false
  app_name = new_resource.app_name
  service_name = new_resource.service_name || app_name
  etc_dir = new_resource.etc_dir || '/etc/slimta'
  executable = new_resource.executable || \
    ::File.join(node['slimta']['virtualenv'], 'bin/slimta')

  app_cfg_file = new_resource.conf_files.fetch('app', "#{app_name}.conf")
  log_cfg_file = new_resource.conf_files.fetch('logging', 'logging.conf')
  rules_cfg_file = new_resource.conf_files.fetch('rules', 'rules.conf')

  tls_info = new_resource.tls || {}
  edge_info = new_resource.edge || {}
  rules_info = new_resource.rules || {}
  queue_info = new_resource.queue || {}
  relay_info = new_resource.relay || {}

  # Create the config directory.
  cfg_dir = directory etc_dir do
    mode 0755
    recursive true
  end
  updated ||= cfg_dir.updated_by_last_action?

  # Create the log directory.
  log_dir = directory new_resource.log_dir do
    mode 0755
    recursive true
  end
  updated ||= log_dir.updated_by_last_action?

  # Create the group the process should run as.
  group = group new_resource.group do
    action :create
  end
  updated ||= group.updated_by_last_action?

  # Create the user the process should run as.
  user = user new_resource.user do
    comment "#{ app_name } user"
    gid new_resource.group
    shell '/bin/false'
    action :create
  end
  updated ||= user.updated_by_last_action?

  # Create the init script.
  init = template ::File.join('/etc/init.d', service_name) do
    cookbook new_resource.cookbook
    source 'slimta.init.erb'
    mode 0755
    variables({
      :app_name => app_name,
      :service_name => service_name,
      :app_cfg_file => ::File.join(etc_dir, app_cfg_file),
      :executable => executable
    })
    action :create
  end
  updated ||= init.updated_by_last_action?

  # Create the service resource.
  service = service service_name do
    supports :status => true, :start => true, :stop => true,
      :restart => true, :reload => true
    action :nothing
  end
  updated ||= service.updated_by_last_action?

  # Create the base configuration file.
  app_cfg = template ::File.join(etc_dir, app_cfg_file) do
    cookbook new_resource.cookbook
    source 'app.conf.erb'
    mode 0644
    variables({
      :app_name => app_name,
      :log_cfg_file => log_cfg_file,
      :rules_cfg_file => rules_cfg_file,
      :user => new_resource.user,
      :group => new_resource.group,
      :log_dir => new_resource.log_dir,
      :log_file => new_resource.log_file,
      :tls_cfg => tls_info,
      :edge_cfg => edge_info,
      :rules_cfg => rules_info,
      :queue_cfg => queue_info,
      :relay_cfg => relay_info,
    })
    action :create
  end
  updated ||= app_cfg.updated_by_last_action?

  # Create the log configuration file.
  log_cfg = template ::File.join(etc_dir, log_cfg_file) do
    cookbook new_resource.cookbook
    source 'logging.conf.erb'
    mode 0644
    variables({
      :app_name => app_name,
      :log_dir => new_resource.log_dir,
      :log_file => new_resource.log_file || "#{ app_name }.log",
    })
    action :create
  end
  updated ||= log_cfg.updated_by_last_action?

  # Create the rules configuration file.
  if not rules_info.empty?
    rules_cfg = template ::File.join(etc_dir, rules_cfg_file) do
      cookbook new_resource.cookbook
      source 'rules.conf.erb'
      mode 0644
      variables({
        :app_name => app_name,
        :rules_cfg => rules_info,
      })
      action :create
    end
    updated ||= rules_cfg.updated_by_last_action?
  end

  new_resource.updated_by_last_action(updated)
end

# vim:sw=2:ts=2:sts=2:et:ai:ft=ruby:
