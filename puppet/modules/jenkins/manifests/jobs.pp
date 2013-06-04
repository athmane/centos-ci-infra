class jenkins::jobs {

file { "/var/lib/jenkins/jobs":
    ensure => directory,
    owner => jenkins,
    group => jenkins,
    mode => 755,
    require => Package['jenkins'],
}

define create_jenkins_job($vm_type, $git_url) {

    file { "/var/lib/jenkins/jobs/$name":
        ensure => directory,
        owner => jenkins,
        group => jenkins,
        mode => 755,
        require => [Package['jenkins'],File['/var/lib/jenkins/jobs']],
    }
    
    file { "/var/lib/jenkins/jobs/$name/config.xml":
        content => template('jenkins/config.xml.erb'),
        owner => jenkins,
        group => jenkins,
        require => [Package['jenkins'],File["/var/lib/jenkins/jobs/$jobname"]],
        notify => Service['jenkins'],
    }


}

# Jenkins jobs

create_jenkins_job {"t_functional-c5-32": 
    vm_type => "c5_32", 
    git_url => "git://gitorious.org/testautomation/t_functional.git",
}

create_jenkins_job {"t_functional-c5-64": 
    vm_type => "c5_32", 
    git_url => "git://gitorious.org/testautomation/t_functional.git",
}

create_jenkins_job {"t_functional-c6-32": 
    vm_type => "c5_32", 
    git_url => "git://gitorious.org/testautomation/t_functional.git",
}

create_jenkins_job {"t_functional-c6-64": 
    vm_type => "c5_32", 
    git_url => "git://gitorious.org/testautomation/t_functional.git",
}

}
