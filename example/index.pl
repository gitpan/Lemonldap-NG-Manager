#!/usr/bin/perl

use Lemonldap::NG::Manager;

my $h = new Lemonldap::NG::Manager(
    {
        configStorage => {
            type    => 'File',
            dirName => "__DIR__/conf/",
        },
        dhtmlXTreeImageLocation => "/imgs/",
        applyConfFile           => '__DIR__/manager/apply.conf',

        # jsFile => /path/to/lemonldap-ng-manager.js,
    }
) or die "Unable to start";

$h->doall();
