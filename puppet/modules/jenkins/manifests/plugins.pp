class jenkins::plugins {

    package {"wget": ensure => present,  }

    # Required by jenkins git plugin
    package {"git":ensure => present, }

    file { "/var/lib/jenkins/plugins" :
          ensure  => directory, 
          owner   => 'jenkins', 
          group   => 'jenkins', 
          mode    => '0755', 
          require => Package["jenkins"], 
    } 

    define install_jenkins_plugin {
      $plugin            = "${name}.hpi"
      $plugin_dir        = '/var/lib/jenkins/plugins'
      $base_url          = 'http://updates.jenkins-ci.org/latest/'

          exec {
        "download-${name}" :
          command    => "wget --no-check-certificate ${base_url}${plugin}", 
          cwd        => $plugin_dir, 
          require    => [Package["wget"], File["${plugin_dir}"]], 
          path       => ['/usr/bin',  '/usr/sbin', ], 
          unless     => "test -f ${plugin_dir}/${plugin}", 
      }

      file {
        "${plugin_dir}/${plugin}" :
          require => Exec["download-${name}"], 
          owner   => 'jenkins', 
          mode    => '0644', 
          notify  => Service['jenkins']
      }
    }

   $jenkins_plugins = [ "ant", 
                        "build-timeout", 
                        "console-column-plugin", 
                        "credentials", 
                        "cvs", 
                        "external-monitor-job", 
                        "git-client", "git", 
                        "gravatar", 
                        "greenballs", 
                        "instant-messaging", 
                        "ircbot", 
                        "javadoc", 
                        "ldap", 
                        "mailer", 
                        "maven-plugin", 
                        "naginator",
                        "pam-auth", 
                        "postbuildscript", 
                        "simple-theme-plugin", 
                        "subversion", 
                        "text-finder", 
                        "throttle-concurrents", 
                        "translation",
                        ]

    install_jenkins_plugin { $jenkins_plugins:; }
}
