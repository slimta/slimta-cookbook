#
# Cookbook Name:: slimta
# Recipe:: default
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

include_recipe "python"

venv = node["slimta"]["virtualenv"]

python_virtualenv venv do
  action :create
end

packages = Set.new [
  "slimta",
  "python-slimta",
  "python-slimta-spf",
  "python-slimta-piperelay",
  "python-slimta-diskstorage",
  "python-slimta-redisstorage",
  "python-slimta-celeryqueue",
  "python-slimta-cloudstorage",
] - node["slimta"]["exclude"]

versions = node["slimta"]["version_lock"]

packages.each do |pkg|
  pkg_version = versions.fetch(pkg, nil)
  python_pip pkg do
    virtualenv venv
    version pkg_version
  end
end

# vim:sw=2:ts=2:sts=2:et:ai:ft=ruby:
