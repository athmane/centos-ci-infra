
class nginx::ci {

    package { "nginx":
        ensure      => present,
    }

    file { "/etc/nginx/nginx.conf":
        source      => "puppet:///modules/nginx/nginx.conf-ci",
        require     => Package["nginx"],
        notify      => Service["nginx"],

    }

    # Recursive did not work in standalone
    file { ["/var/www", "/var/www/cstatic"]:
        ensure      => directory, 
        owner       => root,
        group       => root,
        mode        => 0755,
        require     => File["/etc/nginx/nginx.conf"],
    }

    file { "/var/www/cstatic/centos.png":
        owner       => root,
        group       => root,
        mode        => 0644,
        source      => "puppet:///modules/nginx/centos.png",
        require     => [File["/etc/nginx/nginx.conf"], File["/var/www/cstatic"]],
    }

    file { "/var/www/cstatic/godaddy.png":
        owner       => root,
        group       => root,
        mode        => 0644,
        source      => "puppet:///modules/nginx/godaddy.png",
        require     => [File["/etc/nginx/nginx.conf"], File["/var/www/cstatic"]],
    }

    file { "/var/www/cstatic/index.html":
        owner       => root,
        group       => root,
        mode        => 0644,
        source      => "puppet:///modules/nginx/index.html",
        require     => [File["/etc/nginx/nginx.conf"], File["/var/www/cstatic"]],
    }
 
    service { "nginx":
        enable      => true,
        ensure      => running,
        hasrestart  => true,
        hasstatus   => true,
        require     => File["/etc/nginx/nginx.conf"],
    }

}
