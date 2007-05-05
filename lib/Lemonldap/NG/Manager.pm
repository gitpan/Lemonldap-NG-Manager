package Lemonldap::NG::Manager;

use strict;

use XML::Simple;

use Lemonldap::NG::Manager::Base;
use Lemonldap::NG::Manager::Conf;
use Lemonldap::NG::Manager::_HTML;
require Lemonldap::NG::Manager::_i18n;
require Lemonldap::NG::Manager::Help;
use Lemonldap::NG::Manager::Conf::Constants;
use LWP::UserAgent;
use Safe;
use MIME::Base64;

our @ISA = qw(Lemonldap::NG::Manager::Base);

our $VERSION = '0.64';

sub new {
    my ( $class, $args ) = @_;
    my $self = $class->SUPER::new();
    unless ($args) {
        print STDERR "parameters are required, I can't start so\n";
        return 0;
    }
    %$self = ( %$self, %$args );
    foreach (qw(configStorage dhtmlXTreeImageLocation)) {
        unless ( $self->{$_} ) {
            print STDERR qq/The "$_" parameter is required\n/;
            return 0;
        }
    }
    $self->{jsFile} ||= $self->_dir . "lemonldap-ng-manager.js";
    unless ( -r $self->{jsFile} ) {
        print STDERR qq#Unable to read $self->{jsFile}. You have to set "jsFile" parameter to /path/to/lemonldap-ng-manager.js\n#;
    }
    unless ( __PACKAGE__->can('ldapServer') ) {
        Lemonldap::NG::Manager::_i18n::import( $ENV{HTTP_ACCEPT_LANGUAGE} );
    }
    if ( $self->param('lmQuery') ) {
        my $tmp = "print_" . $self->param('lmQuery');
        $self->$tmp;
    }
    else {
        my $datas;
        if ( $datas = $self->param('POSTDATA') ) {
            $self->print_upload( \$datas );
        }
        else {
            return $self;
        }
    }
    exit;
}

# Subroutines to make all the work
sub doall {
    my $self = shift;
    # When using header_public here, Firefox does not load configuration
    # sometimes. Where is the bug ?
    print $self->header;
    print $self->start_html;
    print $self->main;
    print $self->end_html;
}

# CSS and Javascript export
sub print_css {
    my $self = shift;
    print $self->header_public( $ENV{SCRIPT_FILENAME}, -type => 'text/css' );
    $self->css;
}

sub print_libjs {
    my $self = shift;
    print $self->header_public( $self->{jsFile}, -type => 'application/x-javascript' );
    open F, $self->{jsFile};
    while (<F>) {
        print;
    }
    close F;
}

sub print_lmjs {
    my $self = shift;
    print $self->header_public( $ENV{SCRIPT_FILENAME}, -type => 'text/javascript' );
    $self->javascript;
}

# HELP subroutines

sub print_help {
    my $self = shift;
    print $self->header_public;
    Lemonldap::NG::Manager::Help::import( $ENV{HTTP_ACCEPT_LANGUAGE} )
      unless ( $self->can('help_groups') );
    my $chap = $self->param('help');
    eval { no strict "refs"; &{"help_$chap"} };
}

# Delete subroutine

sub print_delete {
    my $self = shift;
    print $self->header;
    Lemonldap::NG::Manager::Help::import( $ENV{HTTP_ACCEPT_LANGUAGE} )
      unless ( $self->can('help_groups') );
    if ( $self->config->delete ( $self->param ( 'cfgNum' ) ) ) {
        print &txt_configurationDeleted;
    }
    else {
        print &txt_configurationNotDeleted;
    }
    exit;
}

# Configuration download subroutines
sub print_conf {
    my $self = shift;
    print $self->header( -type => "text/xml", '-Cache-Control' => 'private' );
    $self->printXmlConf( { cfgNum => $self->param ( 'cfgNum' ), } );
    exit;
}

sub default {
    return {
        cfgNum   => 0,
        ldapBase => "dc=example,dc=com",
    };
}

sub printXmlConf {
    my $self   = shift;
    print XMLout(
        $self->buildTree( @_ ),
        #XMLDecl  => "<?xml version='1.0' encoding='iso-8859-1'?>",
        RootName => 'tree',
        KeyAttr  => { item => 'id', username => 'name' },
        NoIndent => 1
    );
}

sub buildTree {
    my $self   = shift;
    my $config = $self->config->getConf( @_ );
    $config = $self->default unless ($config);
    my $tree = {
        id   => '0',
        item => {
            id   => 'root',
            open => 1,
            text => &txt_configuration . " $config->{cfgNum}",
            item => {
                generalParameters => {
                    text => &txt_generalParameters,
                    item => {
                        exportedVars => {
                            text => &txt_exportedVars,
                            item => {},
                        },
                        macros => {
                            text => &txt_macros,
                        },
                        ldapParameters => {
                            text => &txt_ldapParameters,
                            item => {},
                        },
                        sessionStorage => {
                            text => &txt_sessionStorage,
                            item => {
                                globalStorageOptions =>
                                  { text => &txt_globalStorageOptions, }
                            },
                        },
                        authParams => {
                            text => &txt_authParams,
                            item => {},
                        },
                    },
                },
                groups       => { text => &txt_userGroups, },
                virtualHosts => {
                    text   => &txt_virtualHosts,
                    open   => 1,
                    select => 1,
                },
            },
        },
    };
    my $generalParameters = $tree->{item}->{item}->{generalParameters}->{item};
    my $exportedVars =
      $tree->{item}->{item}->{generalParameters}->{item}->{exportedVars}->{item};
    my $ldapParameters =
      $tree->{item}->{item}->{generalParameters}->{item}->{ldapParameters}->{item};
    my $sessionStorage =
      $tree->{item}->{item}->{generalParameters}->{item}->{sessionStorage}->{item};
    my $globalStorageOptions =
      $tree->{item}->{item}->{generalParameters}->{item}->{sessionStorage}->{item}->{globalStorageOptions}->{item};
    my $authParams =
      $tree->{item}->{item}->{generalParameters}->{item}->{authParams}->{item};
    $authParams->{authentication} =
      $self->xmlField( "value", $config->{authentication} || 'ldap',
        &txt_authenticationType, );
    $authParams->{portal} =
      $self->xmlField( "value", $config->{portal} || 'http://portal/',
        "Portail" );
    $authParams->{securedCookie} =
      $self->xmlField( "value", $config->{securedCookie} || 0, &txt_securedCookie );
    $generalParameters->{whatToTrace} =
      $self->xmlField( "value", $config->{whatToTrace} || '$uid', &txt_whatToTrace );

    $generalParameters->{domain} =
      $self->xmlField( "value", $config->{domain} || 'example.com', &txt_domain, );
    $generalParameters->{cookieName} =
      $self->xmlField( "value", $config->{cookieName} || 'lemonldap',
        &txt_cookieName, );

    $sessionStorage->{globalStorage} =
      $self->xmlField( "value",
        $config->{globalStorage} || 'Apache::Session::File',
        &txt_apacheSessionModule, );

    $ldapParameters->{ldapServer} =
      $self->xmlField( "value", $config->{ldapServer} || 'localhost',
        &txt_ldapServer, );
    $ldapParameters->{ldapPort} =
      $self->xmlField( "value", $config->{ldapPort} || 389, &txt_ldapPort, );
    $ldapParameters->{ldapBase} =
      $self->xmlField( "value", $config->{ldapBase} || ' ', &txt_ldapBase, );
    $ldapParameters->{managerDn} =
      $self->xmlField( "value", $config->{managerDn} || ' ', &txt_managerDn, );
    $ldapParameters->{managerPassword} =
      $self->xmlField( "value", $config->{managerPassword} || ' ',
        &txt_managerPassword, );

    if ( $config->{exportedVars} ) {
        while ( my ( $n, $att ) = each( %{ $config->{exportedVars} } ) ) {
            $exportedVars->{$n} = $self->xmlField( "both", $att, $n );
        }
    }
    else {
        foreach (qw(mail uid cn)) {
            $exportedVars->{$_} = $self->xmlField( 'both', $_, $_ );
        }
    }

    if ( $config->{globalStorageOptions} and %{ $config->{globalStorageOptions} } ) {
        $tree->{item}->{item}->{generalParameters}->{item}->{sessionStorage}->{item}->{globalStorageOptions}->{item} = {};
        $globalStorageOptions =
          $tree->{item}->{item}->{generalParameters}->{item}->{sessionStorage}->{item}->{globalStorageOptions}->{item};
        while ( my ( $n, $opt ) = each( %{ $config->{globalStorageOptions} } ) )
        {
            $globalStorageOptions->{$n} = $self->xmlField( "both", $opt, $n );
        }
    }
    else {
    }

    my $indice = 1;
    if ( $config->{locationRules} and %{ $config->{locationRules} } ) {
        $tree->{item}->{item}->{virtualHosts}->{item} = {};
        my $virtualHost = $tree->{item}->{item}->{virtualHosts}->{item};
        # TODO: split locationRules into 2 arrays
        while ( my ( $host, $rules ) = each( %{ $config->{locationRules} } ) ) {
            $virtualHost->{$host} = $self->xmlField( "text", 'i', $host );
            my ( $ih, $ir ) =
              ( "exportedHeaders_$indice", "locationRules_$indice" );
            $virtualHost->{$host}->{item} = {
                "$ih" => { text => &txt_httpHeaders, },
                "$ir" => { text => &txt_locationRules, },
            };
            while ( my ( $reg, $expr ) = each(%$rules) ) {
                my $type = ( $reg eq 'default' ) ? 'value' : 'both';
                $virtualHost->{$host}->{item}->{$ir}->{item}->{"r_$indice"} =
                  $self->xmlField( $type, $expr, $reg );
                $indice++;
            }
            my $headers = $config->{exportedHeaders}->{$host};
            while ( my ( $h, $expr ) = each(%$headers) ) {
                $virtualHost->{$host}->{item}->{$ih}->{item}->{"h_$indice"} =
                  $self->xmlField( "both", $expr, $h );
                $indice++;
            }
        }
    }
    if ( $config->{groups} and %{ $config->{groups} } ) {
        $tree->{item}->{item}->{groups}->{item} = {};
        my $groups = $tree->{item}->{item}->{groups}->{item};
        while ( my ( $group, $expr ) = each( %{ $config->{groups} } ) ) {
            $groups->{$group} = $self->xmlField( 'both', $expr, $group );
        }
    }
    if ( $config->{macros} and %{ $config->{macros} } ) {
        $tree->{item}->{item}->{generalParameters}->{item}->{macros}->{item} = {};
        my $macros = $tree->{item}->{item}->{generalParameters}->{item}->{macros}->{item};
        while ( my ( $macro, $expr ) = each( %{ $config->{macros} } ) ) {
            $macros->{$macro} = $self->xmlField( 'both', $expr, $macro );
        }
    }
    return $tree;
}

sub xmlField {
    my ( $self, $type, $value, $text ) = @_;
    $value =~ s/"/\&#34;/g;
    $text  =~ s/"/\&#34;/g;
    return {
        text     => $text,
        aCol     => "#000000",
        sCol     => "#0000FF",
        userdata => [
            { name => 'value', content => $value },
            { name => 'modif', content => $type },
        ],
    };
}

# Upload subroutines
sub print_upload {
    my $self  = shift;
    my $datas = shift;
    print $self->header( -type => "text/html" );
    my $tmp = $self->upload($datas);
    if ($tmp) {
        print $tmp;
    }
    else {
        print 0;
    }
}

sub upload {
    my $self = shift;	
    my $config = $self->tree2conf(@_);
    return SYNTAX_ERROR unless( $self->checkConf($config) );
    return $self->config->saveConf($config);
}

sub tree2conf {
    my ( $self, $tree ) = @_;
    $tree = XMLin($$tree);
    my $config = {};
    # Load config number
    ($config->{cfgNum}) = ($tree->{text} =~ /(\d+)$/);
    # Load groups
    while ( my ( $g, $h ) = each( %{ $tree->{groups} } ) ) {
        next unless ( ref($h) );
        $config->{groups}->{ $h->{text} } = $h->{value};
    }
    # Load virtualHosts
    while ( my ( $vh, $h ) = each( %{ $tree->{virtualHosts} } ) ) {
        next unless ( ref($h) );
        my $lr;
        my $eh;
        foreach ( keys(%$h) ) {
            $lr = $h->{$_} if ( $_ =~ /locationRules/ );
            $eh = $h->{$_} if ( $_ =~ /exportedHeaders/ );
        }
        # TODO: split locationRules into 2 arrays
      LR: foreach my $r ( values(%$lr) ) {
            next LR unless ( ref($r) );
            $config->{locationRules}->{$vh}->{ $r->{text} } = $r->{value};
        }
      EH: foreach my $h ( values(%$eh) ) {
            next EH unless ( ref($h) );
            $config->{exportedHeaders}->{$vh}->{ $h->{text} } = $h->{value};
        }
    }
    # General parameters
    $config->{cookieName} = $tree->{generalParameters}->{cookieName}->{value};
    $config->{whatToTrace} = $tree->{generalParameters}->{whatToTrace}->{value};
    $config->{domain}     = $tree->{generalParameters}->{domain}->{value};
    $config->{globalStorage} = $tree->{generalParameters}->{sessionStorage}->{globalStorage}->{value};
    while ( my ( $v, $h ) = each( %{ $tree->{generalParameters}->{sessionStorage}->{globalStorageOptions} })) {
        next unless ( ref($h) );
        $config->{globalStorageOptions}->{ $h->{text} } = $h->{value};
    }
    while ( my ( $v, $h ) = each( %{ $tree->{generalParameters}->{macros} })) {
        next unless ( ref($h) );
        $config->{macros}->{ $h->{text} } = $h->{value};
    }
    foreach (qw(ldapBase ldapPort ldapServer managerDn managerPassword)) {
        $config->{$_} =
          $tree->{generalParameters}->{ldapParameters}->{$_}->{value};
        $config->{$_} = '' if ( ref( $config->{$_} ) );
        $config->{$_} =~ s/^\s*(.*?)\s*/$1/;
    }
    foreach (qw(authentication portal securedCookie)) {
        $config->{$_} = $tree->{generalParameters}->{authParams}->{$_}->{value};
        $config->{$_} = '' if ( ref( $config->{$_} ) );
        $config->{$_} =~ s/^\s*(.*?)\s*/$1/;
    }
    while ( my ( $v, $h ) =
        each( %{ $tree->{generalParameters}->{exportedVars} } ) )
    {
        next unless ( ref($h) );
        $config->{exportedVars}->{$h->{text}} = $h->{value};
    }
    return $config;
}

sub checkConf {
    my $self = shift;
    my $config = shift;
    my $expr = '';
    # Check cookie name
    return 0 unless( $config->{cookieName} =~ /^\w+$/ );
    # Check domain name
    return 0 unless( $config->{domain} =~ /^[\w\.]+$/ );
    # Load variables
    foreach(keys %{ $config->{exportedVars} }) {
        # Reserved words
        if( $_ eq 'groups' ) {
            print STDERR "$_ is not authorized in attribute names. Change it!\n";
            return 0;
        }
        if( $_ !~ /^\w+$/ ) {
            print STDERR "$_ is not a valid attribute name\n";
            return 0;
        }
        $expr .= "my \$$_ = '1';";
    }
    # Load and check macros
    my $safe = new Safe;
    $safe->share( '&encode_base64' );
    while( my($k, $v) = each( %{ $config->{macros} } ) ) {
        # Reserved words
        if( $k eq 'groups' ) {
            print STDERR "$k is not authorized in macro names. Change it!\n";
            return 0;
        }
        if( $k !~ /^\w+$/ ) {
            print STDERR "$k is not a valid macro name\n";
            return 0;
        }
        $expr .= "my \$$k = $v;";
    }
    # Test macro values;
    $safe->reval( $expr );
    if( $@ ) {
        print STDERR "Error in macro syntax: $@\n";
        return 0;
    }
    # Test groups
    $expr .= 'my $groups;';
    while( my($k,$v) = each( %{ $config->{groups} } ) ) {
        if( $k !~ /^[\w-]+$/ ) {
            print STDERR "$k is not a valid group name\n";
            return 0;
        }
        $safe->reval( $expr . "\$groups = '$k' if($v);");
        if( $@ ) {
            print STDERR "Syntax error in group $k: $@\n";
            return 0;
        }
    }
    # Test rules
    while( my($vh, $rules) = each( %{ $config->{locationRules} } ) ) {
        unless( $vh =~ /^[-\w\.]+$/ ) {
            print STDERR "$vh is not a valid virtual host name\n";
            return 0;
        }
        while( my($reg, $v) = each( %{ $rules } ) ) {
            unless( $reg eq 'default' ) {
                $reg =~ s/#/\\#/g;
                $safe->reval( $expr . "my \$r = qr#$reg#;" );
                if( $@ ) {
                    print STDERR "Syntax error in regexp ($vh -> $reg)\n";
                    return 0;
                }
            }
            unless( $v eq 'deny' or $v eq 'accept' ) {
                $safe->reval( $expr . "my \$r=1 if($v);");
                if( $@ ) {
                    print STDERR "Syntax error in expression ($vh -> $reg)\n";
                    return 0;
                }
            }
        }
    }
    # Test exported headers
    while( my($vh, $headers) = each( %{ $config->{exportedHeaders} } ) ) {
        unless( $vh =~ /^[-\w\.]+$/ ) {
            print STDERR "$vh is not a valid virtual host name\n";
            return 0;
        }
        while( my($header, $v) = each( %{ $headers } ) ) {
            unless( $header =~ /^[\w][-\w]*$/ ) {
                print STDERR "$header is not a valid HTTP header name ($vh)\n";
                return 0;
            }
            $safe->reval( $expr . "my \$r = $v;" );
            if( $@ ) {
                print STDERR "Syntax error in header expression ($vh -> $header)\n";
                return 0;
            }
        }
    }
    1;
}

# Apply subroutines
# TODO: Credentials in applyConfFile

sub print_apply {
    my $self = shift;
    print $self->header( -type => "text/html" );
    unless(-r $self->{applyConfFile} ) {
        print "<h3>".&txt_canNotReadApplyConfFile."</h3>";
        return;
    }
    print '<h3>' . &txt_result . ' : </h3><ul>';
    open F, $self->{applyConfFile};
    my $ua = new LWP::UserAgent( requests_redirectable => [] );
    $ua->timeout(10);
    while(<F>) {
        local $| = 1;
        # pass blank lines and comments
        next if(/^$/ or /^\s*#/);
        chomp;
        s/\r//;
        # each line must be like:
        #    host  http(s)://vhost/request/
        my( $host, $request ) = (/^\s*([^\s]+)\s+([^\s]+)$/);
        unless( $host and $request ) {
            print "<li> ".&txt_invalidLine.": $_</li>";
            next;
        }
        my ( $method, $vhost, $uri ) = ( $request =~ /^(https?):\/\/([^\/]+)(.*)$/ );
        unless($vhost) {
            $vhost = $host;
            $uri = $request;
        }
        print "<li>$host ... ";
        my $r = HTTP::Request->new( 'GET', "$method://$host$uri", HTTP::Headers->new( Host => $vhost ) );#, {Host => $vhost} );
        my $response = $ua->request( $r );
        if ( $response->code != 200 ) {
            print join( ' ', &txt_error, ":", $response->code, $response->message, "</li>");
        }
        else {
            print "OK</li>";
        }
    }
    print "</ul><p>" . &txt_changesAppliedLater . "</p>";
}

# Internal subroutines
sub _dir {
    my $d = $ENV{SCRIPT_FILENAME};
    $d =~ s#[^/]*$##;
    return $d;
}

sub config {
    my $self = shift;
    return $self->{_config} if $self->{_config};
    $self->{_config} =
      Lemonldap::NG::Manager::Conf->new( $self->{configStorage} );
    unless ( $self->{_config} ) {
        die "Configuration not loaded\n";
    }
    return $self->{_config};
}

# Those sub are loaded en demand. With &header_public, they are not loaded each
# time.
*css        = *Lemonldap::NG::Manager::_HTML::css;
*javascript = *Lemonldap::NG::Manager::_HTML::javascript;
*main       = *Lemonldap::NG::Manager::_HTML::main;
*start_html = *Lemonldap::NG::Manager::_HTML::start_html;

__END__

=head1 NAME

Lemonldap::NG::Manager - Perl extension for managing Lemonldap::NG Web-SSO
system.

=head1 SYNOPSIS

  use Lemonldap::NG::Manager;
  my $h=new Lemonldap::NG::Manager(
      {
        configStorage=>{
            type=>'File',
            dirName=>"/tmp/",
        },
        dhtmlXTreeImageLocation=> "/devel/img/",
        # uncomment this only if lemonldap-ng-manager.js is not in the same
        # directory than your script.
        # jsFile => /path/to/lemonldap-ng-manager.js,
      }
    ) or die "Unable to start, see Apache logs";
  # Simple
  $h->doall();

You can also peersonalize the HTML code instead of using C<doall()>:

  print $self->header_public;
  print $self->start_html (  # See CGI(3) for more about start_html
        -style => "/location/to/my.css",
        -title => "Example.com SSO configuration",
        );
  # optional HTML code for the top of the page
  print "<img src=...";
  print $self->main;
  # optional HTML code for the footer of the page
  print "<img src=...";
  
  print $self->end_html;

=head1 DESCRIPTION

Lemonldap::NG::Manager provides a web interface to manage Lemonldap::NG Web-SSO
system.

=head2 SUBROUTINES

=over

=item * B<new> (constructor): new instanciates the manager object. It takes the
following arguments:

=over

=item * B<configStorage> (required): a hash reference to the description of the
configuration database system. the key 'type' must be set. Example:

  configStorage => {
      type => "DBI",
      dbiChain    => "DBI:mysql:database=session;host=1.2.3.4",
      dbiUser     => "lemonldap-ng",
      dbiPassword => "pass",
  }

See L<Lemonldap::Manager::NG::Manager::Conf::File> or
L<Lemonldap::Manager::NG::Manager::Conf::DBI> to know which keys are required.

=item * B<dhtmlXTreeImageLocation> (required): the location of the directory
containing dhtmlXTree images (provided in example/imgs). If this parameter
isn't correct, the tree will not appear and you will have sone error in Apache
error logs.

=item * B<jsFile> (optional): the path to the file C<lemonldap-ng-manager.js>.
It is required only if this file is not in the same directory than your script.

=item * B<applyConfFile> (optional): the path to a file containing parameters
to make configuration reloaded by handlers. See C<reload> function in
L<Lemonldap::NG::Handler>. The configuration file must contains lines like:

  # Comments if wanted
  host  http://virtual-host/reload-path

When this parameter is set, an "apply" button is added to the manager menu.

=back

=item * B<doall>: subroutine that provide headers and the full html code. Il
simply calls C<header_public>, C<start_html>, C<main> and C<end_html> in this
order.

=item * B<header>: print HTTP headers. See L<CGI> for more.

=item * B<header_public>: print HTTP headers and manage the
C<If-Modified-Since> HTTP header. If it match to the age of the file passed
in first argument, it returns C<HTTP 304 Not Modified> end exit. Else, it
calls C<header> with the other arguments. By default, all elements of the
manager use this mecanism except the configuration itself.

=item * B<start_html>: subroutine that print the HTML headers. you can add
parameters to it; example;

  print start_html(-title     => 'My SSO configuration',
                  -author     => 'fred@capricorn.org',
                  -target     => '_blank',
                  -meta       => {'keywords'=>'pharaoh secret mummy',
                  'copyright' => 'copyright 1996 King Tut'},
                  -style      => {'src'=>'/styles/style1.css'},
                  -BGCOLOR    => 'blue');

See start_html description in L<CGI> for more. Bee carefull with C<-style>
argument. You have to call it like the example above or simply like this:
  -style=> '/styles/style1.css',
All other forms will not work.

=item * B<main>: il produce the main HTML code needed to build the
configuration interface.

=item * B<end_html>: close the HTML code by writing C<'E<lt>/bodyE<gt>E<lt>/htmlE<gt>'>

=back

Other subroutines manage the produce of CSS, Javascripts and of course the
configuration tree (called with AJAX).

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

Copyright (C) 2006-2007 by Xavier Guimard

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

