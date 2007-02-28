package Lemonldap::NG::Manager::Apache::Session::SOAP;

use strict;
use SOAP::Lite;

our $VERSION = 0.1;

# Variables shared with SOAP::Transport::HTTP::Client
my ( $username, $password );

# PUBLIC INTERFACE

sub TIEHASH {
    print STDERR "TIEHASH\n";
    my $class = shift;

    my $session_id = shift;
    my $args       = shift;
    my ( $proxy, $proxyOptions );
    die "proxy argument is required"
      unless ( $args and $args->{proxy} );
    my $self = {
        data     => { _session_id => $session_id },
        modified => 0,
    };
    foreach (qw(proxy proxyOptions)) {
        $self->{$_} = $args->{$_};
    }
    ($username, $password) = ( $args->{username}, $args->{password} );
    bless $self, $class;

    if (defined $session_id  && $session_id) {
        die "unexistant session $session_id"
          unless( $self->get( $session_id ) );
    }
    else {
        die "unable to create session"
          unless( $self->newsession());
    }
    return $self;
}

sub FETCH {
    print STDERR "FETCH\n";
    my $self = shift;
    my $key  = shift;
    return $self->{data}->{$key};
}

sub STORE {
    print STDERR "STORE\n";
    my $self  = shift;
    my $key   = shift;
    my $value = shift;

    $self->{data}->{$key} = $value;
    $self->{modified} = 1;
    return $value;
}

sub DELETE {
    print STDERR "DELETE\n";
    my $self = shift;
    my $key  = shift;

    $self->{modified} = 1;

    delete $self->{data}->{$key};
}

sub CLEAR {
    print STDERR "CLEAR\n";
    my $self = shift;

    $self->{modified} = 1;

    $self->{data} = {};
}

sub EXISTS {
    print STDERR "EXISTS\n";
    my $self = shift;
    my $key  = shift;
    return exists $self->{data}->{$key};
}

sub FIRSTKEY {
    print STDERR "FIRESTKEY\n";
    my $self = shift;
    my $reset = keys %{$self->{data}};
    return each %{$self->{data}};
}

sub NEXTKEY {
    print STDERR "NEXTKEY\n";
    my $self = shift;
    return each %{$self->{data}};
}

sub DESTROY {
    print STDERR "DESTROY\n";
    my $self = shift;
    $self->save;
}

# INTERNAL SUBROUTINES

sub _connect {
    my $self = shift;
    return $self->{service} if ( $self->{service} );
    my @args = ( $self->{proxy} );
    if ( $self->{proxyOptions} ) {
        push @args, %{ $self->{proxyOptions} };
    }
    $self->{ns} ||= 'urn:/Lemonldap/NG/Manager/SOAPService/Sessions';
    return $self->{service} = SOAP::Lite->ns( $self->{ns} )->proxy(@args);
}

sub _soapCall {
    my $self = shift;
    my $func = shift;
    return $self->_connect->$func(@_)->result;
}

sub get {
    my $self = shift;
    my $id   = shift;
    return $self->{data} = $self->_soapCall( "get", $id );
}

sub newsession {
    my $self = shift;
    return $self->{data} = $self->_soapCall( "newsession" );
}

sub save {
    my $self = shift;
    return unless ($self->{modified});
    return $self->_soapCall( "set", $self->{_session_id}, $self->{data} );
}

BEGIN {
    sub SOAP::Transport::HTTP::Client::get_basic_credentials {
        return $username => $password;
    }
}

1;
__END__

=head1 NAME

Lemonldap::NG::Manager::Apache::Session::SOAP - Perl extension written to
access to Lemonldap::NG Web-SSO sessions via SOAP.

=head1 SYNOPSIS

=over

=item * With Lemonldap::NG::Handler

  package My::Package;
  use Lemonldap::NG::Handler::SharedConf;

  our @ISA = qw(Lemonldap::NG::Handler::Simple);

  __PACKAGE__->init ({
  	     globalStorage => 'Lemonldap::NG::Manager::Apache::Session::SOAP',
  	     globalStorageOptions => {
  	             proxy => 'http://manager/cgi-bin/soapserver.pl',
  	             proxyOptions => {
  	                 timeout => 5,
  	             },
  	     },
         configStorage       => {
  	         ... # See Lemonldap::NG::Handler

=item * With Lemonldap::NG::Portal

  use Lemonldap::NG::Portal::SharedConf;
  my $portal = new Lemonldap::NG::Portal::SharedConf (
  	     globalStorage => 'Lemonldap::NG::Manager::Apache::Session::SOAP',
  	     globalStorageOptions => {
  	             proxy => 'http://manager/cgi-bin/soapserver.pl',
  	             proxyOptions => {
  	                 timeout => 5,
  	             },
  	     },
        configStorage => {
             ... # See Lemonldap::NG::Portal

You can also set parameters corresponding to "Apache::Session module" in the
manager.

=back

=head1 DESCRIPTION

Lemonldap::NG::Manager::Conf provides a simple interface to access to
Lemonldap::NG Web-SSO configuration. It is used by L<Lemonldap::NG::Handler>,
L<Lemonldap::NG::Portal> and L<Lemonldap::NG::Manager>.

Lemonldap::NG::Manager::Apache::Session::SOAP used with
L<Lemonldap::NG::Manager::SOAPServer> provides the ability to acces to
Lemonldap::NG sessions via SOAP: They act as a proxy to access to the real
Apache::Session module (set as Lemonldap::NG::Manager::SOAPServer parameter).

=head2 SECURITY

As Lemonldap::NG::Manager::Conf::SOAP use SOAP::Lite, you have to see
L<SOAP::Transport> to know arguments that can be passed to C<proxyOptions>.

Example :

=over

=item * HTTP Basic authentication

SOAP::transport can use basic authentication by rewriting
C<>SOAP::Transport::HTTP::Client::get_basic_credentials>:

  package My::Package;
  
  use base Lemonldap::NG::Handler::SharedConf;
  
  # AUTHENTICATION
  BEGIN {
    sub SOAP::Transport::HTTP::Client::get_basic_credentials {
      return 'username' => 'password';
    }
  }
  
  __PACKAGE__->init ( {
      localStorage        => "Cache::FileCache",
      localStorageOptions => {
                'namespace'          => 'MyNamespace',
                'default_expires_in' => 600,
      },
      configStorage       => {
                type  => 'SOAP',
                proxy => 'http://manager.example.com/soapserver.pl',
      },
      https               => 1,
  } );

=item * SSL Authentication

SOAP::transport provides a simple way to use SSL certificate: you've just to
set environment variables.

  package My::Package;
  
  use base Lemonldap::NG::Handler::SharedConf;
  
  # AUTHENTICATION
  $ENV{HTTPS_CERT_FILE} = 'client-cert.pem';
  $ENV{HTTPS_KEY_FILE}  = 'client-key.pem';
  
  __PACKAGE__->init ( {
      localStorage        => "Cache::FileCache",
      localStorageOptions => {
                'namespace'          => 'MyNamespace',
                'default_expires_in' => 600,
      },
      configStorage       => {
                type  => 'SOAP',
                proxy => 'http://manager.example.com/soapserver.pl',
      },
      https               => 1,
  } );

=back

=head1 SEE ALSO

L<Lemonldap::NG::Manager::SOAPServer>,
L<Lemonldap::NG::Manager>, L<Lemonldap::NG::Manager::Conf::SOAP>,
L<Lemonldap::NG::Handler>, L<Lemonldap::NG::Portal>

=head1 AUTHOR

Xavier Guimard, E<lt>x.guimard@free.frE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Xavier Guimard

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
