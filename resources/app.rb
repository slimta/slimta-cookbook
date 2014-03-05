#
# Cookbook Name:: slimta
# Resource:: slimta_app
#
# Copyright (c) 2014 Ian C. Good
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

actions :create
default_action :create

attribute :app_name, :name_attribute => true, :kind_of => String,
  :required => true
attribute :service_name, :kind_of => String
attribute :executable, :kind_of => String
attribute :etc_dir, :kind_of => String
attribute :conf_files, :kind_of => Hash, :default => {}
attribute :user, :kind_of => String, :default => node['slimta']['user']
attribute :group, :kind_of => String, :default => node['slimta']['group']
attribute :log_dir, :kind_of => String, :default => '/var/log/slimta'
attribute :log_file, :kind_of => String
attribute :tls, :kind_of => [Hash, NilClass], :default => nil
attribute :edge, :kind_of => [Hash, NilClass], :default => nil
attribute :rules, :kind_of => [Hash, NilClass], :default => nil
attribute :queue, :kind_of => [Hash, NilClass], :default => nil
attribute :relay, :kind_of => [Hash, NilClass], :default => nil
attribute :cookbook, :kind_of => String

# vim:sw=2:ts=2:sts=2:et:ai:ft=ruby:
