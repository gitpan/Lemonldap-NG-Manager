## @file
# Lemonldap::NG manager main file

## @class
# Lemonldap::NG manager main class
package Lemonldap::NG::Manager;

use strict;
use Lemonldap::NG::Handler::CGI qw(:globalStorage :locationRules);    #inherits
use Lemonldap::NG::Manager::Help;                                     #inherits
use Lemonldap::NG::Common::Conf;              #link protected conf Configuration
use Lemonldap::NG::Common::Conf::Constants;   #inherits

our $VERSION = '0.992';
our @ISA     = qw(
  Lemonldap::NG::Handler::CGI
  Lemonldap::NG::Manager::Downloader
  Lemonldap::NG::Manager::Uploader
  Lemonldap::NG::Manager::Request
  Lemonldap::NG::Manager::_Struct
  Lemonldap::NG::Manager::_i18n
);

## @cmethod Lemonldap::NG::Manager new(hashRef args)
# Class constructor.
#@param args hash reference
#@return Lemonldap::NG::Manager object
sub new {
    my ( $class, $args ) = @_;

    # Output UTF-8
    binmode( STDOUT, ':utf8' );

    # Try to load local configuration parameters
    my $conf = Lemonldap::NG::Common::Conf->new( $args->{configStorage} )
      or Lemonldap::NG::Handler::CGI->abort( 'Unable to get configuration',
        $Lemonldap::NG::Common::Conf::msg );
    if ( my $localconf = $conf->getLocalConf(MANAGERSECTION) ) {
        $args->{$_} ||= $localconf->{$_} foreach ( keys %$localconf );
    }

    my $self = $class->SUPER::new($args)
      or $class->abort( 'Unable to start ' . __PACKAGE__,
        'See Apache logs for more' );

    # Default values
    $self->{managerSkin} = "default"       unless defined $self->{managerSkin};
    $self->{managerCss}  = "accordion.css" unless defined $self->{managerCss};
    $self->{managerTreeAutoClose} = "true"
      unless defined $self->{managerTreeAutoClose};
    $self->{managerTreeJqueryCss} = "true"
      unless defined $self->{managerTreeJqueryCss};

    # Display help if ?help=
    if ( $self->param('help') ) {

        print $self->header_public( $ENV{SCRIPT_FILENAME},
            -type => 'text/html; charset=utf8' );
        &Lemonldap::NG::Manager::Help::import( $self->{language} );
        my $chap = $self->param('help');
        $self->lmLog( "Manager request: Help chapter $chap", 'debug' );
        eval { no strict "refs"; &{"help_$chap"} };
        $self->quit();
    }

    # Save conf if ?data=
    elsif ( my $rdata = $self->rparam('data') ) {

        $self->lmLog( "Manager request: Save data $rdata", 'debug' );
        require Lemonldap::NG::Manager::Uploader;    #inherits
        $self->confUpload($rdata);
        $self->quit();
    }

    # File upload/download
    elsif ( my $rfile = $self->rparam('file') ) {

        $self->lmLog( "Manager request: File $rfile", 'debug' );
        my @params = ('file');
        if ( my $rfilename = $self->rparam('filename') ) {
            push @params, ${$rfilename};
        }
        require Lemonldap::NG::Manager::Uploader;    #inherits
        $self->fileUpload(@params);
        $self->quit();
    }

    # URL upload/download
    elsif ( my $rurl = $self->rparam('url') ) {

        $self->lmLog( "Manager request: URL $rurl", 'debug' );
        require Lemonldap::NG::Manager::Uploader;    #inherits
        $self->urlUpload('url');
        $self->quit();
    }

    # Ask requests
    elsif ( my $rreq = $self->rparam('request') ) {

        $self->lmLog( "Manager request: $rreq", 'debug' );
        require Lemonldap::NG::Manager::Request;     #inherits
        $self->request($rreq);
        $self->quit();
    }

    # Else load conf
    require Lemonldap::NG::Manager::Downloader;      #inherits
    $self->{cfgNum} =
         $self->param('cfgNum')
      || $self->confObj->lastCfg()
      || 'UNAVAILABLE';

    if ( my $p = $self->param('node') ) {

        $self->lmLog( "Manager request: load node $p", 'debug' );
        print $self->header( -type => 'text/html; charset=utf8', );
        print $self->node($p);
        $self->quit();
    }
    if ( $self->param('cfgAttr') ) {

        $self->lmLog( "Manager request: load configuration attributes",
            'debug' );
        $self->sendCfgParams( $self->conf );
    }

    return $self;
}

## @method string menu()
# Build the tree menu.
# @return HTML string
sub menu {
    my $self = shift;
    require Lemonldap::NG::Manager::Downloader;
    return
        '<ul class="simpleTree">' 
      . $self->li( 'root', 'root' )
      . $self->span(
        id   => 'root',
        text => "Configuration $self->{cfgNum}",
        data => $self->{cfgNum},
        js   => 'cfgDatas',
        help => 'default'
      )
      . '<ul>'
      . $self->node()
      . '</ul></li></ul>';
}

1;
__END__

=head1 NAME

=encoding utf8

Lemonldap::NG::Manager - Perl extension for managing Lemonldap::NG Web-SSO
system.

=head1 SYNOPSIS

See example/index.pl

=head1 DESCRIPTION

Lemonldap::NG::Manager provides a web interface to manage Lemonldap::NG Web-SSO
system.

=head1 SEE ALSO

L<Lemonldap::NG::Handler>, L<Lemonldap::NG::Portal>, L<CGI>,
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

Copyright (C) 2006, 2009, 2010 by Xavier Guimard

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
