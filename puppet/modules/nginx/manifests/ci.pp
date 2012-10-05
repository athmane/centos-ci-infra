
class nginx::ci {

    package { "nginx":
        ensure      => present,
    }

    file { "/etc/nginx/nginx.conf":
        source      => "puppet:///modules/nginx/nginx.conf-ci",
        require     => Package["nginx"],
        notify      => Service["nginx"],

    }

    file { "/var/www":
        ensure      => directory,
        owner       => root,
        group       => root,
        mode        => 755,
        require     => Service["nginx"],
    }

    service { "nginx":
        enable      => true,
        ensure      => running,
        hasrestart  => true,
        hasstatus   => true,
        require     => File["/etc/nginx/nginx.conf"],
    }

}
