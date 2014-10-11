
class centos_ci_run {

    file { "/usr/local/etc/centos_ci.cfg":
        source => "puppet:///modules/centos_ci_run/centos_ci.cfg",
	      mode   => 664,	
        owner  => root,
        group  => root,
        replace => false,
    }

    file { "/usr/local/bin/centos_ci_run":
        source => "puppet:///modules/centos_ci_run/centos_ci_run",
	      mode   => 775,	
        owner  => root,
        group  => root,
    }

    # centos_ci_run depends on opennebula

    file { "/etc/yum.repos.d/_opennebula.repo":
        source => "puppet:///modules/centos_ci_run/_opennebula.repo",
    }

     package { "opennebula":
        ensure      => '4.2.0-0.1',
        require	    => File["/etc/yum.repos.d/_opennebula.repo"],
    }


}
