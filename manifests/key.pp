define apt::key($ensure=present, $source="", $content="") {

  case $ensure {

    present: {
      if $content == "" {
        if $source == "" {
          $thekey = "gpg --keyserver keyserver.ubuntu.com --recv-key '${name}' && gpg --export --armor '${name}'"
        }
        else {
          $thekey = "wget -O - '${source}'"
        }
      }
      else {
        $thekey = "echo '${content}'"
      }


      exec { "import gpg key ${name}":
      	path => "/bin:/usr/bin",
        command => "${thekey} | apt-key add -",
        unless => "apt-key list | grep -Fqe '${name}'",
        before => Exec["apt-get_update"],
        notify => Exec["apt-get_update"],
      }
    }
    
    absent: {
      exec {"apt-key del ${name}":
        path => "/bin:/usr/bin",
        onlyif => "apt-key list | grep -Fqe '${name}'",
      }
    }

  }
}
