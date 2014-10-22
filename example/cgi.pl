#!/usr/bin/perl

use Lemonldap::NG::Manager;

my $h=new Lemonldap::NG::Manager(
	{
		configStorage=>{
			type=>'File',
			dirName=>"/tmp/",
		},
		dhtmlXTreeImageLocation=> "/devel/img/",
		# jsFile => /path/to/lemonldap-ng-manager.js,
	}
  ) or die "Impossible de d�marrer";

$h->doall();
