class jenkins::plugins {

    package {"wget":
        ensure      => present,
    }

    exec {"wait-for-jenkins":
        require     => [Service["jenkins"], Package["wget"] ],
        command     => "/usr/bin/wget --spider --tries 20 --retry-connrefused http://localhost:8080/",
        path        => ['/bin','/usr/bin','/usr/local/bin'],
    }

   exec { "download-jenkins-cli":
        command     => "sh -c 'cd /usr/local/bin/ && curl -O http://localhost:8080/jnlpJars/jenkins-cli.jar'",
        path        => ['/bin','/usr/bin','/usr/local/bin'],
        require     => Exec["wait-for-jenkins"],
        creates     => "/usr/local/bin/jenkins-cli.jar",
   }	

   exec { "update-jenkins-updatecenter":
        command     => "curl  -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' | curl -X POST -H 'Accept: application/json' -d @- http://localhost:8080/updateCenter/byId/default/postBack",
        path        => ['/bin','/usr/bin','/usr/local/bin'],
        require     => Exec["wait-for-jenkins"],
   }	

   define install_jenkins_plugin {

      exec { "install-plugin-$name":
           command     => "java -jar /usr/local/bin/jenkins-cli.jar -s http://localhost:8080 install-plugin $name",
           path        => ['/bin','/usr/bin','/usr/local/bin'],
           require     => [ Exec["download-jenkins-cli"], Exec["update-jenkins-updatecenter"]],
           creates     => "/var/lib/jenkins/plugins/$name.jpi",
      }

   }
	
   $jenkins_plugins = ["ant" ,"build-timeout" ,"console-column-plugin" ,"cvs" ,"git" ,"gravatar" ,"greenballs" ,"instant-messaging" ,"ircbot" ,"javadoc" ,"jclouds-jenkins" ,"maven-plugin" ,"postbuildscript" ,"publish-over-ssh" ,"simple-theme-plugin" ,"ssh-slaves" ,"subversion" ,"throttle-concurrents" ,"translation"] 

    install_jenkins_plugin { $jenkins_plugins:; }
}
