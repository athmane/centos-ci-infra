
class nginx::ci {

    package { "nginx":
        ensure      => present,
    }

    file { "/etc/nginx/nginx.conf":
        source      => "puppet:///modules/nginx/nginx.conf-ci",
        require     => Package["nginx"],
        notify      => Service["nginx"],

    }

    file { "/var/www/cstatic":
        ensure      => directory, 
        recurse     => true,
        owner       => root,
        group       => root,
        mode        => 0755,
        source      => "puppet:///modules/nginx/cstatic",
        require     => File["/etc/nginx/nginx.conf"],
    }

    service { "nginx":
        enable      => true,
        ensure      => running,
        hasrestart  => true,
        hasstatus   => true,
        require     => File["/etc/nginx/nginx.conf"],
    }

}
