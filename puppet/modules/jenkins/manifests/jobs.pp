class jenkins::jobs {

define deploy_jenkins_job($jobname) {
    
    file { "/var/lib/jenkins/jobs/$jobname":
        ensure => directory,
        owner => jenkins,
        group => jenkins,
        mode => 755,
        require => Package['jenkins'],
    }
    
    file { "/var/lib/jenkins/jobs/$jobname/config.xml":
        source => "puppet:///modules/jenkins/jobs/$jobname-config.xml",
        owner => jenkins,
        group => jenkins,
        notify => Service['jenkins'],
        require => Package['jenkins'],
    }

}

deploy_jenkins_job {"Development-mamu-c5-32": jobname => "Development-mamu-c5-32",}
deploy_jenkins_job {"Development-mamu-c6-32": jobname => "Development-mamu-c6-32",}
deploy_jenkins_job {"Development-tigalch-c5-32": jobname => "Development-tigalch-c5-32",}
deploy_jenkins_job {"Development-tigalch-c6-32": jobname => "Development-tigalch-c6-32",}
deploy_jenkins_job {"Shadow-c5-32": jobname => "Shadow-c5-32",}
deploy_jenkins_job {"Shadow-c5-64": jobname => "Shadow-c5-64",}
deploy_jenkins_job {"Shadow-c6-32bit": jobname => "Shadow-c6-32bit",}
deploy_jenkins_job {"Shadow-c6-64": jobname => "Shadow-c6-64",}
deploy_jenkins_job {"t_functional-c5-64": jobname => "t_functional-c5-64",}
deploy_jenkins_job {"t_functional-c6-64": jobname => "t_functional-c6-64",}
deploy_jenkins_job {"t_functional-force-kill-rackspace-vms": jobname => "t_functional-force-kill-rackspace-vms",}



}
