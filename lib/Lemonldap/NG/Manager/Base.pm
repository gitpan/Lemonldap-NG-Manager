package Lemonldap::NG::Manager::Base;

use strict;

use MIME::Base64;
use Time::Local;
use CGI;

our $VERSION = '0.1';

our @ISA = qw(CGI);

sub header {
    my $self = shift;
    $self->SUPER::header(@_);
}

sub header_public {
    my $self = shift;
    my $filename = shift;
    my @tmp = stat($filename);
    my $date = $tmp[9];
    my $hd = gmtime($date);
    $hd =~s/^(\w+)\s+(\w+)\s+(\d+)\s+([\d:]+)\s+(\d+)$/$1, $3 $2 $5 $4 GMT/;
    my $year = $5;
    my $cm = $2;
    # TODO 
    if(my $ref = $ENV{TODO_HTTP_IF_MODIFIED_SINCE}) {
	my %month = (jan => 0, feb => 1, mar => 2, apr => 3, may => 4, jun => 5, jul => 6, aug => 7, sep => 8, oct => 9, nov => 10, dec => 11);
	if($ref =~ /^\w+,\s+(\d+)\s+(\w+)\s+(\d+)\s+(\d+):(\d+):(\d+)/) {
	    my $m = $month{lc($2)};
	    $year-- if($m > $month{lc($cm)});
	    $ref = timegm($6,$5,$4,$1,$m,$3);
	    if($ref == $date) {
	        print $self->SUPER::header(-status => '304 Not Modified', @_ );
	        exit;
	    }
	}
    }
    return $self->SUPER::header( '-Last-Modified' => $hd, '-Cache-Control' => 'public', @_ );
}

1;

__END__

=head1 NAME

Lemonldap::NG::Manager::Base - Base module for building Lemonldap::NG
configuration interface

=head1 SYNOPSIS

  use Lemonldap::NG::Base;

=head1 DESCRIPTION

Lemonldap::NG::Portal::Simple is the base module for building Lemonldap::NG
compatible portals. You can use it either by inheritance or by writing
anonymous methods like in the example above.

See L<Lemonldap::NG::Portal::SharedConf::DBI> for a complete example of use of
Lemonldap::Portal::* libraries.

=head1 METHODS

=head2 EXPORT

=head1 SEE ALSO

L<Lemonldap::NG::Handler>, L<Lemonldap::NG::Portal>, L<CGI>

=head1 AUTHOR

Xavier Guimard, E<lt>x.guimard@free.frE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Xavier Guimard E<lt>x.guimard@free.frE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.

=cut
