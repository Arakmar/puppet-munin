# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.
# Adapted and improved by admin(at)immerda.ch

# configure a munin node
class munin::client(
  $allow                      = [ '127.0.0.1' ],
  $host                       = '*',
  $host_name                  = $::fqdn,
  $port                       = '4949',
  $use_ssh                    = false,
  $export_tags                 = [],
  $description                = 'absent',
  $munin_group                = 'absent',
) {

  case $::operatingsystem {
    openbsd: { include munin::client::openbsd }
    debian,ubuntu: { include munin::client::debian }
    gentoo: { include munin::client::gentoo }
    centos: { include munin::client::base }
    default: { include munin::client::base }
  }
}
