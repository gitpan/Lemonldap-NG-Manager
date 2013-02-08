# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Lemonldap-NG-Manager-Sessions.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 1;
use strict;

BEGIN {
    use_ok('Lemonldap::NG::Manager::Sessions');
}

__END__

