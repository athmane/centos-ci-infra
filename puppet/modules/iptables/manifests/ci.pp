
class iptables::ci {

    file { "/etc/sysconfig/iptables":
        source => "puppet:///modules/iptables/iptables-ci",
	mode   => 600,	
        owner  => root,
        group  => root,
        notify => Service['iptables'],
    }

    service { "iptables":
        enable      => true,
        ensure      => running,
        hasrestart  => true,
        hasstatus   => true,
        require     => File["/etc/sysconfig/iptables"],
    }

}
