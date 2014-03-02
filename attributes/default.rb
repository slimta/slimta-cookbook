
default['slimta']['virtualenv'] = '/opt/slimta'

default['slimta']['exclude'] = []
default['slimta']['version_lock'] = {}

process_defaults = default['slimta']['defaults']['process']
process_defaults['user'] = 'slimta'
process_defaults['group'] = 'slimta'

logging_defaults = default['slimta']['defaults']['logging']
logging_defaults['directory'] = '/var/log/slimta'
logging_defaults['file'] = 'slimta.log'

edge_defaults = default['slimta']['defaults']['edge']
edge_defaults['main']['type'] = 'smtp'
edge_defaults['main']['interface'] = ''
edge_defaults['main']['port'] = 25

rules_defaults = default['slimta']['defaults']['rules']
rules_defaults['main']['banner'] = "#{node['fqdn']} ESMTP Mail Delivery Agent"
rules_defaults['main']['reject_spf'] = ['fail']
rules_defaults['main']['only_recipients'] = [
  "postmaster@#{node['fqdn']}",
  "admin@#{node['fqdn']}",
]

queue_defaults = default['slimta']['defaults']['queue']
queue_defaults['main']['type'] = 'memory'
queue_defaults['main']['policies'] = [
  {type: 'add_date_header'},
  {type: 'add_messageid_header'},
  {type: 'add_received_header'},
  {type: 'recipient_domain_split'},
]

relay_defaults = default['slimta']['defaults']['relay']
relay_defaults['main']['type'] = 'mx'
relay_defaults['main']['ehlo_as'] = nil

# vim:sw=2:ts=2:sts=2:et:ai:ft=ruby:
