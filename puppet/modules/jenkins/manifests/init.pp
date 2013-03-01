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

 

}
