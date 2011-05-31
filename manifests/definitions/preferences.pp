define apt::preferences($ensure="present", $package="", $pin, $priority) {

  $pkg = $package ? {
    "" => $name,
    default => $package,
  }

  $fname = regsubst($name, '\.', '-', 'G')

  # apt support preferences.d since version >= 0.7.22
  case $lsbdistcodename {
    /lucid|squeeze/ : {   
      file {"/etc/apt/preferences.d/$fname":
        ensure  => $ensure,
        owner   => root,
        group   => root,
        mode    => 644,
        content => template("apt/preferences.erb"),
        before  => Exec["apt-get_update"],
        notify  => Exec["apt-get_update"],
      }

    }
    default: {
      common::concatfilepart { $fname:
        ensure  => $ensure,
        manage  => true,
        file    => "/etc/apt/preferences",
        content => template("apt/preferences.erb"),
        before  => Exec["apt-get_update"],
        notify  => Exec["apt-get_update"],
      }
    }
  }
}
