# TODO: Split into two classes

class jenkins {

    exec { "install-jenkins-key":
        command     => "rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key",
        unless      => "rpm -q gpg-pubkey-d50582e6-4a3feef6",
        path        => ["/bin", "/usr/bin"],
    }

    file { "/etc/yum.repos.d/jenkins.repo":
	source => "puppet:///modules/jenkins/jenkins.repo",
    }

    package {"java-1.6.0-openjdk":
        ensure      => present,
    }

    package { "jenkins":
        ensure      => present,
        require	    => [ File["/etc/yum.repos.d/jenkins.repo"], Package["java-1.6.0-openjdk"]],
    }

    service { "jenkins":
        enable      => true,
        ensure      => running,
        hasrestart  => true,
        hasstatus   => true,
        require     => Package["jenkins"],
    }

   exec { "download-jenkins-cli":
        command     => "sh -c 'cd /usr/local/bin/ && curl -O http://localhost/jnlpJars/jenkins-cli.jar'",
        path        => ['/bin','/usr/bin','/usr/local/bin'],
        require     => Service["jenkins"],
        creates     => "/usr/local/bin/jenkins-cli.jar",
   }	

   exec { "update-jenkins-updatecenter":
        command     => "curl  -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack",
        path        => ['/bin','/usr/bin','/usr/local/bin'],
        require     => Service["jenkins"],
   }	

   define install_jenkins_plugin($plugin_name) {

      exec { "install-plugin-$plugin_name":
           command     => "java -jar /usr/local/bin/jenkins-cli.jar -s http://localhost:8080 install-plugin $plugin_name",
           path        => ['/bin','/usr/bin','/usr/local/bin'],
           require     => [ Exec["download-jenkins-cli"], Exec["update-jenkins-updatecenter"]],
           creates     => "/var/lib/jenkins/plugins/$plugin_name.jpi",
      }

   }
	
   install_jenkins_plugin {"ant": plugin_name => "ant",}
   install_jenkins_plugin {"build-timeout": plugin_name => "build-timeout",}
   install_jenkins_plugin {"console-column-plugin": plugin_name => "console-column-plugin",}
   install_jenkins_plugin {"cvs": plugin_name => "cvs",}
   install_jenkins_plugin {"git": plugin_name => "git",}
   install_jenkins_plugin {"gravatar": plugin_name => "gravatar",}
   install_jenkins_plugin {"greenballs": plugin_name => "greenballs",}
   install_jenkins_plugin {"instant-messaging": plugin_name => "instant-messaging",}
   install_jenkins_plugin {"ircbot": plugin_name => "ircbot",}
   install_jenkins_plugin {"javadoc": plugin_name => "javadoc",}
   install_jenkins_plugin {"jclouds-jenkins": plugin_name => "jclouds-jenkins",}
   install_jenkins_plugin {"maven-plugin": plugin_name => "maven-plugin",}
   install_jenkins_plugin {"postbuildscript": plugin_name => "postbuildscript",}
   install_jenkins_plugin {"publish-over-ssh": plugin_name => "publish-over-ssh",}
   install_jenkins_plugin {"simple-theme-plugin": plugin_name => "simple-theme-plugin",}
   install_jenkins_plugin {"ssh-slaves": plugin_name => "ssh-slaves",}
   install_jenkins_plugin {"subversion": plugin_name => "subversion",}
   install_jenkins_plugin {"throttle-concurrents": plugin_name => "throttle-concurrents",}
   install_jenkins_plugin {"translation": plugin_name => "translation",}
  
}
