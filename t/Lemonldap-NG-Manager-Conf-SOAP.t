# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Lemonldap-NG-Manager.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 1;

# SOAP::Lite is not required, so Lemonldap::NG::Manager::Conf::SOAP may
# not run.
SKIP: {
    eval { require SOAP::Lite };
    skip
      "SOAP::Lite is not installed, so SOAP configuration access will not work",
      1
      if ($@);
    use_ok('Lemonldap::NG::Manager::Conf::SOAP');
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

