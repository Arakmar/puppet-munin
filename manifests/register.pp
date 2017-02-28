# Register a munin client
define munin::register (
  $host         = $::fqdn,
  $port         = '4949',
  $use_ssh      = false,
  $description  = 'absent',
  $config       = [],
  $export_tags   = [],
  $group        = 'absent',
)
{
  validate_array($export_tags)

  if (empty($export_tags)) {
    $tag_array = ['munin_client']
  } else {
    $tag_array = prefix($export_tags, "munin_client_")
  }

  @@concat::fragment{ "munin_client_${::fqdn}":
    target  => '/etc/munin/munin.conf',
    content => template('munin/client.erb'),
    tag     => $tag_array,
  }
}
