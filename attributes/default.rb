
default['slimta']['virtualenv'] = '/opt/slimta'

default['slimta']['install_extensions'] = [
  'python-slimta-spf',
  'python-slimta-piperelay',
  'python-slimta-diskstorage',
  'python-slimta-redisstorage',
]

default['slimta']['version_lock'] = {}

default['slimta']['user'] = 'slimta'
default['slimta']['group'] = 'slimta'

# vim:sw=2:ts=2:sts=2:et:ai:ft=ruby:
