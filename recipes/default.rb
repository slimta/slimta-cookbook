#
# Cookbook Name:: slimta
# Recipe:: default
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

include_recipe 'python'

venv = node['slimta']['virtualenv']

python_virtualenv venv do
  action :create
end

packages = ['python-slimta', 'slimta'] + node['slimta']['install_extensions']

package_locations = node['slimta']['package_locations']
versions = node['slimta']['version_lock']

packages.each do |pkg|
  pkg_version = versions.fetch(pkg, nil)
  pkg_source = package_locations.fetch(pkg, pkg)
  python_pip pkg_source do
    virtualenv venv
    version pkg_version
    action :upgrade
    node['slimta']['services'].each do |service|
      notifies :restart, "service[#{ service }]"
    end
  end
end

# vim:sw=2:ts=2:sts=2:et:ai:ft=ruby:
