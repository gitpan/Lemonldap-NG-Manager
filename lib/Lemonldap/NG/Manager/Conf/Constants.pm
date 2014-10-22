package Lemonldap::NG::Manager::Conf::Constants;

use strict;
use Exporter 'import';

our @ISA = qw(Exporter);
our $VERSION = '0.1';

# CONSTANTS

use constant CONFIG_WAS_CHANGED => -1;
use constant UNKNOWN_ERROR => -2;
use constant DATABASE_LOCKED => -3;

our %EXPORT_TAGS = ( 'all' => [ qw(
    CONFIG_WAS_CHANGED
    UNKNOWN_ERROR
    DATABASE_LOCKED
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = ( @{ $EXPORT_TAGS{'all'} } );

1;
__END__
