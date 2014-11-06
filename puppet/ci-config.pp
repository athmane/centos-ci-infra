
include jenkins 

# Only needed one time 
#include jenkins::plugins
#include jenkins::jobs

include iptables::ci 
include nginx::ci
include centos_ci_run
