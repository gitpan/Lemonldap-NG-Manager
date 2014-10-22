package Lemonldap::NG::Manager::Conf;

use strict;
no strict 'refs';
use Data::Dumper;
use Lemonldap::NG::Manager::Conf::Constants;

our $VERSION = 0.51;
our @ISA;

sub new {
    my $class = shift;
    my $args;
    if ( ref( $_[0] ) ) {
        $args = $_[0];
    }
    else {
        %$args = @_;
    }
    $args ||= {};
    my $self = bless $args, $class;
    unless ( $self->{mdone} ) {
        unless ( $self->{type} ) {
            print STDERR "configStorage: type is not defined\n";
            return 0;
        }
        $self->{type} = "Lemonldap::NG::Manager::Conf::$self->{type}"
          unless $self->{type} =~ /^Lemonldap/;
        eval "require $self->{type}";
        die($@) if ($@);
        return 0 unless $self->prereq;
        $self->{mdone}++;
    }
    return $self;
}

sub saveConf {
    my ( $self, $conf ) = @_;
    # If configuration was modified, return an error
    return CONFIG_WAS_CHANGED if( $conf->{cfgNum} != $self->lastCfg or $self->isLocked );
    $self->lock or return DATABASE_LOCKED;
    my $fields;
    local $Data::Dumper::Indent = 0;
    local $Data::Dumper::Varname = "data";
    while ( my ( $k, $v ) = each(%$conf) ) {
        if ( ref($v) ) {
            $fields->{$k} = Dumper($v);
            $fields->{$k} =~ s/'/&#39;/g;
            $fields->{$k} = "'$fields->{$k}'";
        }
        elsif ( $v =~ /^\d+$/ ) {
            $fields->{$k} = "$v";
        }
        else {
            # mono-line
            $v =~ s/[\r\n]/ /gm;
            # trim
            $v =~ s/^\s*(.*?)\s*$/$1/;
            $fields->{$k} = "'$v'";
        }
    }
    $fields->{cfgNum} = $self->lastCfg + 1;
    return $self->store($fields);
}

sub getConf {
    my ( $self, $args ) = @_;
    $args->{cfgNum} ||= $self->lastCfg;
    return undef unless $args->{cfgNum};
    if ( $args->{cfgNum}<0 ) {
        my @a = $self->available();
        $args->{cfgNum} = ( @a + $args->{cfgNum} >0 ) ? ( $a[ $#a + $args->{cfgNum} ] ) : $a[0];
    }
    my $fields = $self->load( $args->{cfgNum}, $args->{fields} );
    my $conf;
    while ( my ( $k, $v ) = each(%$fields) ) {
        $v =~ s/^'(.*)'$/$1/s;
        if( $k =~ /^(?:exportedVars|locationRules|groups|exportedHeaders|macros|globalStorageOptions)$/ ) {
            if ( $v !~ /^\$/ ) {
                print STDERR "Lemonldap::NG : Warning: configuration is in old format, you've to migrate !\n";
                eval 'require Storable;require MIME::Base64;';
		die($@) if($@);
                $conf->{$k} = Storable::thaw(MIME::Base64::decode_base64($v));
            }
            else {
                my $data;
                $v =~ s/^\$([_a-zA-Z][_a-zA-Z0-9]*) *=/\$data =/;
                $v =~ s/&#?39;/'/g;
                eval $v;
                print STDERR "Lemonldap::NG : Error while reading configuration with $k key: $@\n" if($@);
                $conf->{$k} = $data;
            }
        }
        else {
            $conf->{$k} = $v;
        }
    }
    return $conf;
}

sub prereq {
    return &{$_[0]->{type}.'::prereq'}(@_);
}

sub available {
    return &{$_[0]->{type}.'::available'}(@_);
}

sub lastCfg {
    return &{$_[0]->{type}.'::lastCfg'}(@_);
}

sub lock {
    return &{$_[0]->{type}.'::lock'}(@_);
}

sub isLocked {
    return &{$_[0]->{type}.'::isLocked'}(@_);
}

sub unlock {
    return &{$_[0]->{type}.'::unlock'}(@_);
}

sub store {
    return &{$_[0]->{type}.'::store'}(@_);
}

sub load {
    return &{$_[0]->{type}.'::load'}(@_);
}

sub delete {
    my($self, $c) = @_;
    my @a = $self->available();
    return 0 unless ( @a + $c >0 );
    return &{$self->{type}.'::delete'}( $self, $a[ $#a + $c ] );
}

1;
__END__

=head1 NAME

Lemonldap::NG::Manager::Conf - Perl extension written to manage Lemonldap::NG
Web-SSO configuration.

=head1 SYNOPSIS

  use Lemonldap::NG::Manager::Conf;
  my $confAccess = new Lemonldap::NG::Manager::Conf(
                  {
                  type=>'File',
                  dirName=>"/tmp/",
                  },
    ) or die "Unable to build Lemonldap::NG::Manager::Conf, see Apache logs";
  my $config = $confAccess->getConf();

=head1 DESCRIPTION

Lemonldap::NG::Manager::Conf provides a simple interface to access to
Lemonldap::NG Web-SSO configuration. It is used by L<Lemonldap::NG::Handler>,
L<Lemonldap::NG::Portal> and L<Lemonldap::NG::Manager>.

=head2 SUBROUTINES

=over

=item * B<new> (constructor): it takes different arguments depending on the
choosen type. Examples:

=over

=item * B<File>:
  $confAccess = new Lemonldap::NG::Manager::Conf(
                {
                type    => 'File',
                dirName => '/var/lib/lemonldap-ng/',
                });

=item * B<DBI>:
  $confAccess = new Lemonldap::NG::Manager::Conf(
                {
                type        => 'DBI',
                dbiChain    => 'DBI:mysql:database=lemonldap-ng;host=1.2.3.4',
                dbiUser     => 'lemonldap'
                dbiPassword => 'pass'
                dbiTable    => 'lmConfig',
                });

=item * B<SOAP>:
  $confAccess = new Lemonldap::NG::Manager::Conf(
                {
                type         => 'SOAP',
                proxy        => 'https://manager.example.com/soapmanager.pl',
                proxyOptions => {
                                timeout => 5,
                                },
                });

SOAP configuration access is a sort of proxy: the SOAP server that runs
L<Lemonldap::NG::Manager::SOAPServer> is configured to use the real session
storage type (DBI or File for example). See L<Lemonldap::NG::Conf::SOAP> for
more.

=back

WARNING: You have to use the same storage type on all Lemonldap::NG parts in
the same server.

=item * B<getConf>: returns a hash reference to the configuration. it takes
a hash reference as first argument containing 2 optional parameters:

=over

=item * C<cfgNum => $number>: the number of the configuration wanted. If this
argument is omitted, the last configuration is returned.

=item * C<fields => [array of names]: the desired fields asked. By default,
getConf returns all (C<select * from lmConfig>).

=back

=item * B<saveConf>: stores the Lemonldap::NG configuration passed in argument
(hash reference). it returns the number of the new configuration.

=back

=head1 SEE ALSO

L<Lemonldap::NG::Handler>, L<Lemonldap::NG::Portal>,
http://wiki.lemonldap.objectweb.org/xwiki/bin/view/NG/Presentation

=head1 AUTHOR

Xavier Guimard, E<lt>x.guimard@free.frE<gt>

=head1 BUG REPORT

Use OW2 system to report bug or ask for features:
L<http://forge.objectweb.org/tracker/?group_id=274>

=head1 DOWNLOAD

Lemonldap::NG is available at
L<http://forge.objectweb.org/project/showfiles.php?group_id=274>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006-2007 by Xavier Guimard

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
