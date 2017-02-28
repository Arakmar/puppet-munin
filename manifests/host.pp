# host.pp - the master host of the munin installation
# Copyright (C) 2007 David Schmitt <david@schmitt.edv-bus.at>
# See LICENSE for the full license granted to you.

class munin::host(
  $export_tag = undef
) {
  package {'munin': ensure => installed, }

  $real_export_tag = $export_tag ? {
    undef => 'munin_client',
    default => "munin_client_${export_tag}"
  }
  Concat::Fragment <<| tag == $real_export_tag |>>

  concat::fragment{'munin.conf.header':
    target => '/etc/munin/munin.conf',
    source => [ "puppet:///modules/munin/config/host/munin.conf.header.${::operatingsystem}.${::lsbdistcodename}",
                "puppet:///modules/munin/config/host/munin.conf.header.${::operatingsystem}",
                'puppet:///modules/munin/config/host/munin.conf.header' ],
    order  => 05,
  }

  concat{ '/etc/munin/munin.conf':
    owner => root,
    group => 0,
    mode  => '0644',
  }

  include munin::plugins::muninhost

  # from time to time we cleanup hanging munin-runs
  file{'/etc/cron.d/munin_kill':
    content => "4,34 * * * * root if $(ps ax | grep -v grep | grep -q munin-run); then killall munin-run; fi\n",
    owner   => root,
    group   => 0,
    mode    => '0644',
  }
}
