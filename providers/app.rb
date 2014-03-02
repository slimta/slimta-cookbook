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
  executable = new_resource.executable || \
    ::File.join(node['slimta']['virtualenv'], 'bin/slimta')
  etc_dir = new_resource.etc_dir || \
    ::File.join(node['slimta']['virtualenv'], 'etc')

  app_cfg_file = new_resource.conf_files.fetch('app', "#{app_name}.conf")
  log_cfg_file = new_resource.conf_files.fetch('logging', 'logging.conf')
  rules_cfg_file = new_resource.conf_files.fetch('rules', 'rules.conf')

  process_cfg = new_resource.process || node['slimta']['defaults']['process']
  logging_cfg = new_resource.logging || node['slimta']['defaults']['logging']
  edge_cfg = new_resource.edge || node['slimta']['defaults']['edge']
  rules_cfg = new_resource.rules || node['slimta']['defaults']['rules']
  queue_cfg = new_resource.queue || node['slimta']['defaults']['queue']
  relay_cfg = new_resource.relay || node['slimta']['defaults']['relay']

  # Create the config directory.
  cfg_dir = directory etc_dir do
    mode 0755
    recursive true
  end
  updated ||= cfg_dir.updated_by_last_action?

  # Create the log directory.
  log_dir = directory logging_cfg['directory'] do
    mode 0755
    recursive true
  end
  updated ||= log_dir.updated_by_last_action?

  # Create the group the process should run as.
  group = group process_cfg['group'] do
    action :create
  end
  updated ||= group.updated_by_last_action?

  # Create the user the process should run as.
  user = user process_cfg['user'] do
    comment "#{ app_name } user"
    gid process_cfg['group']
    shell '/bin/false'
    action :create
  end
  updated ||= user.updated_by_last_action?

  # Create the init script.
  init = template ::File.join('/etc/init.d', app_name) do
    cookbook new_resource.cookbook
    source 'slimta.init.erb'
    mode 0755
    variables({
      :app_name => app_name,
      :app_cfg_file => ::File.join(etc_dir, app_cfg_file),
      :executable => executable
    })
    action :create
  end
  updated ||= init.updated_by_last_action?

  # Create the service resource.
  service = service app_name do
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
      :process_cfg => process_cfg,
      :logging_cfg => logging_cfg,
      :edge_cfg => edge_cfg,
      :rules_cfg => rules_cfg,
      :queue_cfg => queue_cfg,
      :relay_cfg => relay_cfg,
    })
    notifies :restart, "service[#{ app_name }]"
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
      :logging_cfg => logging_cfg,
    })
    action :create
  end
  updated ||= log_cfg.updated_by_last_action?

  # Create the rules configuration file.
  rules_cfg = template ::File.join(etc_dir, rules_cfg_file) do
    cookbook new_resource.cookbook
    source 'rules.conf.erb'
    mode 0644
    variables({
      :app_name => app_name,
      :rules_cfg => rules_cfg,
    })
    action :create
  end
  updated ||= rules_cfg.updated_by_last_action?

  new_resource.updated_by_last_action(updated)
end

# vim:sw=2:ts=2:sts=2:et:ai:ft=ruby:
