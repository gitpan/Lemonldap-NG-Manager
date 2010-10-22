## @file
# Manager tree structure and tests

## @class
# Manager tree structure and tests
package Lemonldap::NG::Manager::_Struct;

use strict;
use Lemonldap::NG::Common::Conf::SAML::Metadata;
use Lemonldap::NG::Common::Regexp;

our $VERSION = '0.99.1';

## @method protected hashref cstruct(hashref h,string k)
# Merge $h with the structure produced with $k and return it.
# Used to manage virtual hosts, and metadatas (IDP, SP).
#@param $h Result of struct()
#@param $k Full path of the key
#@return Tree structure
sub cstruct {
    shift;
    my ( $h, $k ) = @_;
    my @tmp = split( /\//, $k );
    return $h unless ( scalar(@tmp) > 1 );
    my $k1 = $tmp[0];
    my $k2 = $tmp[1];
    if ( $k1 =~ /^virtualHosts/i ) {
        %$h = (
            %$h,
            virtualHosts => {
                $k2 => {
                    _nodes => [
                        qw(rules:rules:rules headers post:post:post vhostOptions)
                    ],
                    rules => {
                        _nodes => ["hash:/locationRules/$k2:rules:rules"],
                        _js    => 'rulesRoot'
                    },
                    headers => {
                        _nodes => ["hash:/exportedHeaders/$k2"],
                        _js    => 'hashRoot'
                    },
                    post => {
                        _nodes => ["post:/post/$k2:post:post"],
                        _js    => 'postRoot'
                    },
                    vhostOptions => {
                        _nodes     => [qw(vhostPort vhostHttps)],
                        vhostPort  => "int:/vhostOptions/$k2/vhostPort",
                        vhostHttps => "trool:/vhostOptions/$k2/vhostHttps",
                    },
                }
            }
        );
    }
    elsif ( $k1 =~ /^samlIDPMetaDataNode/i ) {
        %$h = (
            %$h,
            samlIDPMetaDataNode => {
                $k2 => {
                    _nodes => [
                        qw(samlIDPMetaDataXML samlIDPMetaDataExportedAttributes samlIDPMetaDataOptions)
                    ],
                    samlIDPMetaDataExportedAttributes => {
                        _nodes => [
                                "hash:/samlIDPMetaDataExportedAttributes/$k2"
                              . ":samlIDPMetaDataExportedAttributes:samlAttribute"
                        ],
                        _js => 'samlAttributeRoot'
                    },
                    samlIDPMetaDataXML => "samlmetadata:/samlIDPMetaDataXML/$k2"
                      . ":samlIDPMetaDataXML:filearea",
                    samlIDPMetaDataOptions => {
                        _nodes => [
                            qw(samlIDPMetaDataOptionsResolutionRule samlIDPMetaDataOptionsAuthnRequest samlIDPMetaDataOptionsSession samlIDPMetaDataOptionsSignature samlIDPMetaDataOptionsBinding samlIDPMetaDataOptionsSecurity)
                        ],

                        samlIDPMetaDataOptionsResolutionRule =>
"textarea:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsResolutionRule",

                        samlIDPMetaDataOptionsAuthnRequest => {
                            _nodes => [
                                qw(samlIDPMetaDataOptionsNameIDFormat samlIDPMetaDataOptionsForceAuthn samlIDPMetaDataOptionsIsPassive samlIDPMetaDataOptionsAllowProxiedAuthn samlIDPMetaDataOptionsAllowLoginFromIDP samlIDPMetaDataOptionsRequestedAuthnContext)
                            ],

                            samlIDPMetaDataOptionsNameIDFormat =>
"text:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsNameIDFormat"
                              . ":default:nameIdFormatParams",
                            samlIDPMetaDataOptionsForceAuthn =>
"bool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsForceAuthn",
                            samlIDPMetaDataOptionsIsPassive =>
"bool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsIsPassive",
                            samlIDPMetaDataOptionsAllowProxiedAuthn =>
"bool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsAllowProxiedAuthn",
                            samlIDPMetaDataOptionsAllowLoginFromIDP =>
"bool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsAllowLoginFromIDP",
                            samlIDPMetaDataOptionsRequestedAuthnContext =>
"text:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsRequestedAuthnContext"
                              . ":default:authnContextParams",

                        },

                        samlIDPMetaDataOptionsSession => {
                            _nodes => [
                                qw(samlIDPMetaDataOptionsAdaptSessionUtime samlIDPMetaDataOptionsForceUTF8)
                            ],

                            samlIDPMetaDataOptionsAdaptSessionUtime =>
"bool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsAdaptSessionUtime",
                            samlIDPMetaDataOptionsForceUTF8 =>
"bool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsForceUTF8",

                        },

                        samlIDPMetaDataOptionsSignature => {
                            _nodes => [
                                qw(samlIDPMetaDataOptionsSignSSOMessage samlIDPMetaDataOptionsCheckSSOMessageSignature samlIDPMetaDataOptionsSignSLOMessage samlIDPMetaDataOptionsCheckSLOMessageSignature)
                            ],

                            samlIDPMetaDataOptionsSignSSOMessage =>
"trool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsSignSSOMessage",
                            samlIDPMetaDataOptionsCheckSSOMessageSignature =>
"bool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsCheckSSOMessageSignature",
                            samlIDPMetaDataOptionsSignSLOMessage =>
"trool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsSignSLOMessage",
                            samlIDPMetaDataOptionsCheckSLOMessageSignature =>
"bool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsCheckSLOMessageSignature",

                        },

                        samlIDPMetaDataOptionsBinding => {
                            _nodes => [
                                qw(samlIDPMetaDataOptionsSSOBinding samlIDPMetaDataOptionsSLOBinding)
                            ],

                            samlIDPMetaDataOptionsSSOBinding =>
"text:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsSSOBinding"
                              . ":default:bindingParams",
                            samlIDPMetaDataOptionsSLOBinding =>
"text:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsSLOBinding"
                              . ":default:bindingParams",

                        },

                        samlIDPMetaDataOptionsSecurity => {
                            _nodes => [
                                qw(samlIDPMetaDataOptionsEncryptionMode samlIDPMetaDataOptionsCheckConditions)
                            ],

                            samlIDPMetaDataOptionsEncryptionMode =>
"text:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsEncryptionMode:default:encryptionModeParams",
                            samlIDPMetaDataOptionsCheckConditions =>
"bool:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsCheckConditions",

                        },

                    },
                }
            }
        );
    }
    elsif ( $k1 =~ /^samlSPMetaDataNode/i ) {
        %$h = (
            %$h,
            samlSPMetaDataNode => {
                $k2 => {
                    _nodes => [
                        qw(samlSPMetaDataXML samlSPMetaDataExportedAttributes samlSPMetaDataOptions)
                    ],
                    samlSPMetaDataExportedAttributes => {
                        _nodes => [
                                "hash:/samlSPMetaDataExportedAttributes/$k2"
                              . ":samlSPMetaDataExportedAttributes:samlAttribute"
                        ],
                        _js => 'samlAttributeRoot'
                    },
                    samlSPMetaDataXML => "samlmetadata:/samlSPMetaDataXML/$k2"
                      . ":samlSPMetaDataXML:filearea",
                    samlSPMetaDataOptions => {
                        _nodes => [
                            qw(samlSPMetaDataOptionsAuthnResponse samlSPMetaDataOptionsSignature samlSPMetaDataOptionsSecurity)
                        ],

                        samlSPMetaDataOptionsAuthnResponse => {
                            _nodes => [
                                qw(samlSPMetaDataOptionsNameIDFormat samlSPMetaDataOptionsOneTimeUse)
                            ],

                            samlSPMetaDataOptionsNameIDFormat =>
"text:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsNameIDFormat"
                              . ":default:nameIdFormatParams",
                            samlSPMetaDataOptionsOneTimeUse =>
"bool:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsOneTimeUse",
                        },

                        samlSPMetaDataOptionsSignature => {
                            _nodes => [
                                qw(samlSPMetaDataOptionsSignSSOMessage samlSPMetaDataOptionsCheckSSOMessageSignature samlSPMetaDataOptionsSignSLOMessage samlSPMetaDataOptionsCheckSLOMessageSignature)
                            ],

                            samlSPMetaDataOptionsSignSSOMessage =>
"trool:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsSignSSOMessage",
                            samlSPMetaDataOptionsCheckSSOMessageSignature =>
"bool:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsCheckSSOMessageSignature",
                            samlSPMetaDataOptionsSignSLOMessage =>
"trool:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsSignSLOMessage",
                            samlSPMetaDataOptionsCheckSLOMessageSignature =>
"bool:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsCheckSLOMessageSignature",
                        },
                        samlSPMetaDataOptionsSecurity => {

                            _nodes => [qw(samlSPMetaDataOptionsEncryptionMode)],

                            samlSPMetaDataOptionsEncryptionMode =>
"text:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsEncryptionMode:default:encryptionModeParams",
                        },
                    },
                }
            }
        );
    }
    return $h;
}

## @method protected hashref struct(hashref h,string k)
# Returns the tree structure
#@return Tree structure
sub struct {
    my $self = shift;
    return {
        _nodes => [
            qw(n:generalParameters n:variables n:virtualHosts n:samlServiceMetaData n:samlIDPMetaDataNode n:samlSPMetaDataNode)
        ],
        _help => 'default',

        ######################
        # GENERAL PARAMETERS #
        ######################
        generalParameters => {
            _nodes => [
                qw(n:portalParams n:authParams n:issuerParams n:logParams n:cookieParams n:sessionParams n:advancedParams)
            ],
            _help => 'default',

            # PORTAL PARAMETERS
            portalParams => {
                _nodes => [qw(portal n:portalMenu n:portalCustomization)],
                _help  => 'portalParams',

                portal => 'text:/portal:portal:text',

                portalMenu => {
                    _nodes        => [qw(portalModules applicationList)],
                    portalModules => {
                        _nodes => [
                            qw(portalDisplayLogout portalDisplayChangePassword portalDisplayAppslist)
                        ],
                        portalDisplayLogout => 'text:/portalDisplayLogout',
                        portalDisplayChangePassword =>
                          'text:/portalDisplayChangePassword',
                        portalDisplayAppslist => 'text:/portalDisplayAppslist',
                    },
                    applicationList => {
                        _nodes => [
'applicationlist:/applicationList:default:applicationListCategory'
                        ],
                        _js => 'applicationListCategoryRoot',
                    },
                },

                portalCustomization => {
                    _nodes => [
                        qw(portalSkin portalDisplayResetPassword portalAutocomplete portalRequireOldPassword portalUserAttr portalOpenLinkInNewWindow)
                    ],

                    portalSkin => 'text:/portalSkin:portalParams:skinSelect',
                    portalDisplayResetPassword =>
                      'bool:/portalDisplayResetPassword',
                    portalAutocomplete => 'bool:/portalAutocomplete',
                    portalRequireOldPassword =>
                      'bool:/portalRequireOldPassword',
                    portalUserAttr => 'text:/portalUserAttr',
                    portalOpenLinkInNewWindow =>
                      'bool:/portalOpenLinkInNewWindow',
                },
            },

            # AUTHENTICATION / USERDB / PASWWORDDB PARAMETERS
            authParams => {

               # Displayed nodes depend on authentication/userDB modules choosed
                _nodes => sub {
                    my $self = shift;
                    my $auth = $self->conf->{authentication}
                      || $self->defaultConf()->{authentication};
                    my $udb = $self->conf->{userDB}
                      || $self->defaultConf()->{userDB};
                    my $pdb = $self->conf->{passwordDB}
                      || $self->defaultConf()->{passwordDB};
                    $auth = lc($auth);
                    $auth =~ s/\s.*$//;    # For Multi
                    $udb = lc($udb);
                    $pdb = lc($pdb);
                    my %res;

                    foreach my $mod (
                        (
                            $auth,
                            ( $udb ne ( $auth or $pdb ) ? $udb : () ),
                            ( $pdb ne ( $auth or $udb ) ? $pdb : () ),
                        )
                      )
                    {
                        my $tmp = {
                            ldap    => ['ldapParams'],
                            ssl     => [qw(ldapParams sslParams)],
                            cas     => ['casParams'],
                            remote  => ['remoteParams'],
                            proxy   => ['proxyParams'],
                            openid  => ['openIdParams'],
                            twitter => ['twitterParams'],
                            dbi     => ['dbiParams'],
                            apache  => ['apacheParams'],
                            null    => ['nullParams'],
                            choice  => [
                                qw(ldapParams sslParams casParams remoteParams proxyParams openIdParams twitterParams dbiParams apacheParams nullParams choiceParams)
                            ],
                            multi => [
                                qw(ldapParams sslParams casParams remoteParams proxyParams openIdParams twitterParams dbiParams apacheParams nullParams choiceParams)
                            ],
                        }->{$mod};
                        if ($tmp) {
                            $res{$_}++ foreach (@$tmp);
                        }
                    }
                    my @u = keys %res;

    # Add authentication, userDB, passwordDB and issuerDB nodes at the beginning
                    unshift( @u, "passwordDB" );
                    unshift( @u, "userDB" );
                    unshift( @u, "authentication" );

                    # Return nodes
                    return \@u;
                },

                _help => 'authParams',

                authentication => 'text:/authentication:authParams:authParams',
                userDB         => 'text:/userDB:authParams:userdbParams',
                passwordDB => 'text:/passwordDB:authParams:passworddbParams',

                # LDAP
                ldapParams => {
                    _nodes => [
                        qw(ldapAuthnLevel n:ldapConnection n:ldapFilters n:ldapGroups n:ldapPassword)
                    ],
                    _help => 'ldap',

                    ldapAuthnLevel => 'int:/ldapAuthnLevel',

                    ldapConnection => {
                        _nodes => [
                            qw(ldapServer ldapPort ldapBase managerDn managerPassword ldapTimeout ldapVersion ldapRaw)
                        ],
                        ldapServer      => 'text:/ldapServer',
                        ldapPort        => 'int:/ldapPort',
                        ldapBase        => 'text:/ldapBase',
                        managerDn       => 'text:/managerDn',
                        managerPassword => 'text:/managerPassword',
                        ldapTimeout     => 'int:/ldapTimeout',
                        ldapVersion     => 'int:/ldapVersion',
                        ldapRaw         => 'text:/ldapRaw',
                    },

                    ldapFilters => {
                        _nodes =>
                          [qw(LDAPFilter AuthLDAPFilter mailLDAPFilter)],
                        LDAPFilter     => 'text:/LDAPFilter',
                        AuthLDAPFilter => 'text:/AuthLDAPFilter',
                        mailLDAPFilter => 'text:/mailLDAPFilter',
                    },

                    ldapGroups => {
                        _nodes => [
                            qw(ldapGroupBase ldapGroupObjectClass ldapGroupAttributeName ldapGroupAttributeNameUser ldapGroupAttributeNameSearch ldapGroupRecursive ldapGroupAttributeNameGroup)
                        ],
                        ldapGroupBase        => 'text:/ldapGroupBase',
                        ldapGroupObjectClass => 'text:/ldapGroupObjectClass',
                        ldapGroupAttributeName =>
                          'text:/ldapGroupAttributeName',
                        ldapGroupAttributeNameUser =>
                          'text:/ldapGroupAttributeNameUser',
                        ldapGroupAttributeNameSearch =>
                          'text:/ldapGroupAttributeNameSearch',
                        ldapGroupRecursive => 'bool:/ldapGroupRecursive',
                        ldapGroupAttributeNameGroup =>
                          'text:/ldapGroupAttributeNameGroup',
                    },

                    ldapPassword => {
                        _nodes => [
                            qw(ldapPpolicyControl ldapSetPassword ldapChangePasswordAsUser ldapPwdEnc)
                        ],
                        ldapPpolicyControl => 'bool:/ldapPpolicyControl',
                        ldapSetPassword    => 'bool:/ldapSetPassword',
                        ldapChangePasswordAsUser =>
                          'bool:/ldapChangePasswordAsUser',
                        ldapPwdEnc => 'text:/ldapPwdEnc',
                    },

                },

                # SSL
                sslParams => {
                    _nodes =>
                      [qw(SSLAuthnLevel SSLVar SSLLDAPField SSLRequire)],
                    SSLAuthnLevel => 'int:/SSLAuthnLevel',
                    SSLVar        => 'text:/SSLVar',
                    SSLLDAPField  => 'text:/SSLLDAPField',
                    SSLRequire    => 'bool:/SSLRequire',
                },

                # CAS
                casParams => {
                    _nodes => [
                        qw(CAS_authnLevel CAS_url CAS_CAFile CAS_renew CAS_gateway CAS_pgtFile cn:CAS_proxiedServices)
                    ],
                    CAS_authnLevel      => 'int:/CAS_authnLevel',
                    CAS_url             => 'text:/CAS_url',
                    CAS_CAFile          => 'text:/CAS_CAFile',
                    CAS_renew           => 'bool:/CAS_renew',
                    CAS_gateway         => 'bool:/CAS_gateway',
                    CAS_pgtFile         => 'text:/CAS_pgtFile',
                    CAS_proxiedServices => {
                        _nodes => ['hash:/CAS_proxiedServices:default:btext'],
                        _js    => 'hashRoot',
                        _help  => 'default',
                    },

                },

                # Remote
                remoteParams => {
                    _nodes => [
                        qw(remotePortal remoteCookieName remoteGlobalStorage cn:remoteGlobalStorageOptions)
                    ],
                    remotePortal               => 'text:/remotePortal',
                    remoteCookieName           => 'text:/remoteCookieName',
                    remoteGlobalStorage        => 'text:/remoteGlobalStorage',
                    remoteGlobalStorageOptions => {
                        _nodes =>
                          ['hash:/remoteGlobalStorageOptions:default:btext'],
                        _js   => 'hashRoot',
                        _help => 'default',
                    },
                },

                # Proxy
                proxyParams => {
                    _nodes =>
                      [qw(soapAuthService remoteCookieName soapSessionService)],
                    soapAuthService    => 'text:/soapAuthService',
                    remoteCookieName   => 'text:/remoteCookieName',
                    soapSessionService => 'text:/soapSessionService',
                },

                # OpenID
                openIdParams => {
                    _nodes => [qw(openIdAuthnLevel openIdSecret openIdIDPList)],
                    openIdAuthnLevel => 'int:/openIdAuthnLevel',
                    openIdSecret     => 'text:/openIdSecret',
                    openIdIDPList =>
                      'text:/openIdIDPList:authopenid:openididplist',
                },

                # Twitter
                twitterParams => {
                    _nodes => [
                        qw(twitterAuthnLevel twitterKey twitterSecret twitterAppName)
                    ],
                    twitterAuthnLevel => 'int:/twitterAuthnLevel',
                    twitterKey        => 'text:/twitterKey',
                    twitterSecret     => 'text:/twitterSecret',
                    twitterAppName    => 'text:/twitterAppName',
                },

                # DBI
                dbiParams => {
                    _nodes => [
                        qw(dbiAuthnLevel n:dbiConnection n:dbiSchema n:dbiPassword)
                    ],

                    dbiAuthnLevel => 'int:/dbiAuthnLevel',

                    dbiConnection => {
                        _nodes => [qw(n:dbiConnectionAuth n:dbiConnectionUser)],

                        dbiConnectionAuth => {
                            _nodes =>
                              [qw(dbiAuthChain dbiAuthUser dbiAuthPassword)],
                            dbiAuthChain    => 'text:/dbiAuthChain',
                            dbiAuthUser     => 'text:/dbiAuthUser',
                            dbiAuthPassword => 'text:/dbiAuthPassword',
                        },

                        dbiConnectionUser => {
                            _nodes =>
                              [qw(dbiUserChain dbiUserUser dbiUserPassword)],
                            dbiUserChain    => 'text:/dbiUserChain',
                            dbiUserUser     => 'text:/dbiUserUser',
                            dbiUserPassword => 'text:/dbiUserPassword',
                        },
                    },

                    dbiSchema => {
                        _nodes => [
                            qw(dbiAuthTable dbiUserTable dbiAuthLoginCol dbiAuthPasswordCol dbiAuthMailCol userPivot)
                        ],
                        dbiAuthTable       => 'text:/dbiAuthTable',
                        dbiUserTable       => 'text:/dbiUserTable',
                        dbiAuthLoginCol    => 'text:/dbiAuthLoginCol',
                        dbiAuthPasswordCol => 'text:/dbiAuthPasswordCol',
                        dbiAuthMailCol     => 'text:/dbiAuthMailCol',
                        userPivot          => 'text:/userPivot',
                    },

                    dbiPassword => {
                        _nodes              => [qw(dbiAuthPasswordHash)],
                        dbiAuthPasswordHash => 'text:/dbiAuthPasswordHash',
                    },
                },

                # Apache
                apacheParams => {
                    _nodes           => [qw(apacheAuthnLevel)],
                    apacheAuthnLevel => 'int:/apacheAuthnLevel',
                },

                # Null
                nullParams => {
                    _nodes         => [qw(nullAuthnLevel)],
                    nullAuthnLevel => 'int:/nullAuthnLevel',
                },

                # Choice
                choiceParams => {
                    _nodes => [qw(authChoiceParam n:authChoiceModules)],
                    authChoiceParam   => 'text:/authChoiceParam',
                    authChoiceModules => {
                        _nodes =>
                          ['hash:/authChoiceModules:default:authChoice'],
                        _js   => 'authChoiceRoot',
                        _help => 'default',
                    },
                },

            },

            # ISSUERDB PARAMETERS
            issuerParams => {
                _nodes       => [qw(issuerDBSAML issuerDBCAS issuerDBOpenID)],
                issuerDBSAML => {
                    _nodes => [
                        qw(issuerDBSAMLActivation issuerDBSAMLPath issuerDBSAMLRule)
                    ],
                    issuerDBSAMLActivation => 'bool:/issuerDBSAMLActivation',
                    issuerDBSAMLPath       => 'text:/issuerDBSAMLPath',
                    issuerDBSAMLRule       => 'text:/issuerDBSAMLRule',
                },
                issuerDBCAS => {
                    _nodes => [
                        qw(issuerDBCASActivation issuerDBCASPath issuerDBCASRule issuerDBCASOptions)
                    ],
                    issuerDBCASActivation => 'bool:/issuerDBCASActivation',
                    issuerDBCASPath       => 'text:/issuerDBCASPath',
                    issuerDBCASRule       => 'text:/issuerDBCASRule',
                    issuerDBCASOptions    => {
                        _nodes => [qw(casAttr casStorage cn:casStorageOptions)],
                        casAttr           => 'text:casAttr',
                        casStorage        => 'text:/casStorage',
                        casStorageOptions => {
                            _nodes => ['hash:/casStorageOptions:default:btext'],
                            _js    => 'hashRoot',
                            _help  => 'default',
                        },
                    },
                },
                issuerDBOpenID => {
                    _nodes => [
                        qw(issuerDBOpenIDActivation issuerDBOpenIDPath issuerDBOpenIDRule n:issuerDBOpenIDOptions)
                    ],
                    issuerDBOpenIDActivation =>
                      'bool:/issuerDBOpenIDActivation',
                    issuerDBOpenIDPath    => 'text:/issuerDBOpenIDPath',
                    issuerDBOpenIDRule    => 'text:/issuerDBOpenIDRule',
                    issuerDBOpenIDOptions => {
                        _nodes => [
                            qw(openIdIssuerSecret openIdAttr openIdSPList n:openIdSreg)
                        ],
                        openIdIssuerSecret => 'text:/openIdIssuerSecret',
                        openIdAttr         => 'text:openIdAttr',
                        openIdSPList =>
                          'text:/openIdSPList:issuerdbopenid:openididplist',
                        openIdSreg => {
                            _nodes => [
                                qw(openIdSreg_fullname openIdSreg_nickname openIdSreg_language openIdSreg_postcode openIdSreg_timezone openIdSreg_country openIdSreg_gender openIdSreg_email openIdSreg_dob)
                            ],
                            openIdSreg_fullname => 'text:openIdSreg_fullname',
                            openIdSreg_nickname => 'text:openIdSreg_nickname',
                            openIdSreg_language => 'text:openIdSreg_language',
                            openIdSreg_postcode => 'text:openIdSreg_postcode',
                            openIdSreg_timezone => 'text:openIdSreg_timezone',
                            openIdSreg_country  => 'text:openIdSreg_country',
                            openIdSreg_gender   => 'text:openIdSreg_gender',
                            openIdSreg_email    => 'text:openIdSreg_email',
                            openIdSreg_dob      => 'text:openIdSreg_dob',
                        },
                    },
                },
            },

            # LOGS PARAMETERS
            logParams => {
                _nodes => [qw(syslog useXForwardedForIP whatToTrace)],
                syslog => 'text:/syslog',
                useXForwardedForIP => 'bool:/useXForwardedForIP',
                whatToTrace        => 'text:/whatToTrace:whatToTrace:text',
            },

            # COOKIE PARAMETERS
            cookieParams => {
                _nodes =>
                  [qw(cookieName domain cda securedCookie cookieExpiration)],
                _help      => 'cookies',
                cookieName => 'text:/cookieName:cookieName:text',
                domain     => 'text:/domain:domain:text',
                cda        => 'bool:/cda',
                securedCookie =>
                  'select:/securedCookie:securedCookie:securedCookieValues',
                cookieExpiration => 'text:/cookieExpiration',
            },

            # SESSIONS PARAMETERS
            sessionParams => {
                _nodes => [
                    qw(grantSessionRule storePassword timeout timeoutActivity n:sessionStorage n:multipleSessions)
                ],
                _help => 'storage',

                grantSessionRule => 'textarea:/grantSessionRule',
                storePassword    => 'bool:/storePassword',
                timeout          => 'int:/timeout:timeout:int',
                timeoutActivity =>
                  'text:/timeoutActivity:timeoutActivity:timeoutActivityParams',

                sessionStorage => {
                    _nodes => [qw(globalStorage cn:globalStorageOptions)],
                    globalStorage        => 'text:/globalStorage',
                    globalStorageOptions => {
                        _nodes => ['hash:/globalStorageOptions:storage:btext'],
                        _js    => 'hashRoot',
                        _help  => 'storage',
                    },
                },

                multipleSessions => {
                    _nodes => [
                        qw(singleSession singleIP singleUserByIP notifyDeleted notifyOther)
                    ],
                    singleSession  => 'bool:/singleSession',
                    singleIP       => 'bool:/singleIP',
                    singleUserByIP => 'bool:/singleUserByIP',
                    notifyDeleted  => 'bool:/notifyDeleted',
                    notifyOther    => 'bool:/notifyOther',
                },
            },

            # OTHER PARAMETERS
            advancedParams => {
                _nodes => [
                    qw(customFunctions n:soap n:notifications n:passwordManagement n:security n:redirection n:specialHandlers cn:logoutServices)
                ],

                customFunctions => 'text:/customFunctions',

                soap => {
                    _nodes         => [qw(Soap exportedAttr trustedDomains)],
                    Soap           => 'bool:/Soap',
                    exportedAttr   => 'text:/exportedAttr',
                    trustedDomains => 'text:/trustedDomains',
                },

                notifications => {
                    _nodes => [
                        qw(notification notificationStorage cn:notificationStorageOptions)
                    ],
                    _help                      => 'notifications',
                    notification               => 'bool:/notification',
                    notificationStorage        => 'text:/notificationStorage',
                    notificationStorageOptions => {
                        _nodes => [
'hash:/notificationStorageOptions:notifications:btext'
                        ],
                        _js   => 'hashRoot',
                        _help => 'notifications',
                    },
                },

                passwordManagement => {
                    _nodes => [
                        qw(SMTPServer mailUrl mailFrom mailSubject mailBody mailConfirmSubject mailConfirmBody randomPasswordRegexp)
                    ],
                    SMTPServer           => 'text:/SMTPServer',
                    mailUrl              => 'text:/mailUrl',
                    mailFrom             => 'text:/mailFrom',
                    mailSubject          => 'text:/mailSubject',
                    mailBody             => 'textarea:/mailBody',
                    mailConfirmSubject   => 'text:/mailConfirmSubject',
                    mailConfirmBody      => 'textarea:/mailConfirmBody',
                    randomPasswordRegexp => 'text:/randomPasswordRegexp',
                },

                security => {
                    _nodes      => [qw(userControl portalForceAuthn key)],
                    userControl => 'text:/userControl:userControl:text',
                    portalForceAuthn =>
                      'bool:/portalForceAuthn:portalForceAuthn:bool',
                    key => 'text:/key:key:text',
                },

                redirection => {
                    _nodes => [
                        qw(https port useRedirectOnForbidden useRedirectOnError)
                    ],
                    https  => 'bool:/https',
                    port   => 'int:/port',
                    useRedirectOnForbidden => 'bool:/useRedirectOnForbidden',
                    useRedirectOnError     => 'bool:/useRedirectOnError',
                },

                specialHandlers => {
                    _nodes => [qw(zimbraHandler sympaHandler)],

                    # Zimbra
                    zimbraHandler => {
                        _nodes => [
                            qw(zimbraPreAuthKey zimbraAccountKey zimbraBy zimbraUrl zimbraSsoUrl)
                        ],
                        zimbraPreAuthKey => 'text:/zimbraPreAuthKey',
                        zimbraAccountKey => 'text:/zimbraAccountKey',
                        zimbraBy     => 'text:/zimbraBy:default:zimbraByParams',
                        zimbraUrl    => 'text:/zimbraUrl',
                        zimbraSsoUrl => 'text:/zimbraSsoUrl',
                    },

                    # Sympa
                    sympaHandler => {
                        _nodes       => [qw(sympaSecret sympaMailKey)],
                        sympaSecret  => 'text:/sympaSecret',
                        sympaMailKey => 'text:/sympaMailKey',
                    },
                },

                logoutServices => {
                    _nodes => ['hash:/logoutServices:default:btext'],
                    _js    => 'hashRoot',
                    _help  => 'default',
                },

            },
        },

        #############
        # VARIABLES #
        #############

        variables => {
            _nodes => [qw(cn:exportedVars cn:macros cn:groups)],
            _help  => 'default',

            # EXPORTED ATTRIBUTES
            exportedVars => {
                _nodes => ['hash:/exportedVars:vars:btext'],
                _js    => 'hashRoot',
                _help  => 'vars',
            },

            # MACROS
            macros => {
                _nodes => ['hash:/macros:macros:btext'],
                _js    => 'hashRoot',
                _help  => 'macros',
            },

            # GROUPS
            groups => {
                _nodes => ['hash:/groups:groups:btext'],
                _js    => 'hashRoot',
                _help  => 'groups',
            },
        },

        #################
        # VIRTUAL HOSTS #
        #################
        virtualHosts => {
            _nodes  => ['nhash:/locationRules:virtualHosts:vhost'],
            _upload => [qw(/exportedHeaders /post /vhostOptions)],
            _help   => 'virtualHosts',
            _js     => 'vhostRoot',
        },

        ########
        # SAML #
        ########
        # virtual keys should not begin like configuration keys.
        samlIDPMetaDataNode => {
            _nodes => [
'nhash:/samlIDPMetaDataExportedAttributes:samlIDPMetaDataNode:samlIdpMetaData'
            ],
            _upload => [ '/samlIDPMetaDataXML', '/samlIDPMetaDataOptions' ],
            _help   => 'default',
            _js     => 'samlIdpRoot',
        },

        samlSPMetaDataNode => {
            _nodes => [
'nhash:/samlSPMetaDataExportedAttributes:samlSPMetaDataNode:samlSpMetaData'
            ],
            _upload => [ '/samlSPMetaDataXML', '/samlSPMetaDataOptions' ],
            _help   => 'default',
            _js     => 'samlSpRoot',
        },

        samlServiceMetaData => {
            _nodes => [
                qw(samlEntityID
                  n:samlServiceSecurity
                  n:samlNameIDFormatMap
                  n:samlAuthnContextMap
                  n:samlOrganization
                  n:samlSPSSODescriptor
                  n:samlIDPSSODescriptor
                  n:samlAttributeAuthorityDescriptor
                  n:samlAdvanced)
            ],
            _help => 'default',

            # GLOBAL INFORMATIONS
            samlEntityID => 'text:/samlEntityID',

            # SECURITY NODE
            samlServiceSecurity => {
                _nodes =>
                  [qw(n:samlServiceSecuritySig n:samlServiceSecurityEnc)],
                _help                  => 'default',
                samlServiceSecuritySig => {
                    _nodes => [
                        qw(samlServicePrivateKeySig
                          samlServicePrivateKeySigPwd
                          samlServicePublicKeySig)
                    ],
                    _help => 'default',
                    samlServicePrivateKeySig =>
'filearea:/samlServicePrivateKeySig:samlServicePrivateKeySig:filearea',
                    samlServicePrivateKeySigPwd =>
                      'text:/samlServicePrivateKeySigPwd',
                    samlServicePublicKeySig =>
'filearea:/samlServicePublicKeySig:samlServicePublicKeySig:filearea',
                },
                samlServiceSecurityEnc => {
                    _nodes => [
                        qw(samlServicePrivateKeyEnc
                          samlServicePrivateKeyEncPwd
                          samlServicePublicKeyEnc)
                    ],
                    _help => 'default',
                    samlServicePrivateKeyEnc =>
'filearea:/samlServicePrivateKeyEnc:samlServicePrivateKeyEnc:filearea',
                    samlServicePrivateKeyEncPwd =>
                      'text:/samlServicePrivateKeyEncPwd',
                    samlServicePublicKeyEnc =>
'filearea:/samlServicePublicKeyEnc:samlServicePublicKeyEnc:filearea',
                },
            },

            # NAMEID FORMAT MAP
            samlNameIDFormatMap => {
                _nodes => [
                    qw(samlNameIDFormatMapEmail samlNameIDFormatMapX509 samlNameIDFormatMapWindows samlNameIDFormatMapKerberos)
                ],
                _help                    => 'default',
                samlNameIDFormatMapEmail => 'text:/samlNameIDFormatMapEmail',
                samlNameIDFormatMapX509  => 'text:/samlNameIDFormatMapX509',
                samlNameIDFormatMapWindows =>
                  'text:/samlNameIDFormatMapWindows',
                samlNameIDFormatMapKerberos =>
                  'text:/samlNameIDFormatMapKerberos',
            },

            # AUTHN CONTEXT MAP
            samlAuthnContextMap => {
                _nodes => [
                    qw(samlAuthnContextMapPassword samlAuthnContextMapPasswordProtectedTransport samlAuthnContextMapTLSClient samlAuthnContextMapKerberos)
                ],
                _help => 'default',
                samlAuthnContextMapPassword =>
                  'int:/samlAuthnContextMapPassword',
                samlAuthnContextMapPasswordProtectedTransport =>
                  'int:/samlAuthnContextMapPasswordProtectedTransport',
                samlAuthnContextMapTLSClient =>
                  'int:/samlAuthnContextMapTLSClient',
                samlAuthnContextMapKerberos =>
                  'int:/samlAuthnContextMapKerberos',
            },

            # ORGANIZATION
            samlOrganization => {
                _nodes => [
                    qw(samlOrganizationDisplayName
                      samlOrganizationName
                      samlOrganizationURL)
                ],
                _help => 'default',
                samlOrganizationDisplayName =>
                  'text:/samlOrganizationDisplayName',
                samlOrganizationURL  => 'text:/samlOrganizationURL',
                samlOrganizationName => 'text:/samlOrganizationName',
            },

            # SERVICE PROVIDER
            'samlSPSSODescriptor' => {
                _nodes => [
                    qw(samlSPSSODescriptorAuthnRequestsSigned
                      samlSPSSODescriptorWantAssertionsSigned
                      n:samlSPSSODescriptorSingleLogoutService
                      n:samlSPSSODescriptorAssertionConsumerService
                      n:samlSPSSODescriptorArtifactResolutionService
                      )
                ],
                _help => 'default',

                samlSPSSODescriptorAuthnRequestsSigned =>
                  'bool:/samlSPSSODescriptorAuthnRequestsSigned',
                samlSPSSODescriptorWantAssertionsSigned =>
                  'bool:/samlSPSSODescriptorWantAssertionsSigned',

                samlSPSSODescriptorSingleLogoutService => {
                    _nodes => [
                        qw(samlSPSSODescriptorSingleLogoutServiceHTTPRedirect
                          samlSPSSODescriptorSingleLogoutServiceHTTPPost
                          samlSPSSODescriptorSingleLogoutServiceSOAP)
                    ],
                    _help => 'default',
                    samlSPSSODescriptorSingleLogoutServiceHTTPRedirect =>
'samlService:/samlSPSSODescriptorSingleLogoutServiceHTTPRedirect',
                    samlSPSSODescriptorSingleLogoutServiceHTTPPost =>
'samlService:/samlSPSSODescriptorSingleLogoutServiceHTTPPost',
                    samlSPSSODescriptorSingleLogoutServiceSOAP =>
                      'samlService:/samlSPSSODescriptorSingleLogoutServiceSOAP',
                },

                samlSPSSODescriptorAssertionConsumerService => {
                    _nodes => [
                        qw(samlSPSSODescriptorAssertionConsumerServiceHTTPArtifact
                          samlSPSSODescriptorAssertionConsumerServiceHTTPPost)
                    ],
                    _help => 'default',
                    samlSPSSODescriptorAssertionConsumerServiceHTTPArtifact =>
'samlAssertion:/samlSPSSODescriptorAssertionConsumerServiceHTTPArtifact',
                    samlSPSSODescriptorAssertionConsumerServiceHTTPPost =>
'samlAssertion:/samlSPSSODescriptorAssertionConsumerServiceHTTPPost',
                },

                samlSPSSODescriptorArtifactResolutionService => {
                    _nodes => [
                        qw(samlSPSSODescriptorArtifactResolutionServiceArtifact)
                    ],
                    _help => 'default',
                    samlSPSSODescriptorArtifactResolutionServiceArtifact =>
'samlAssertion:/samlSPSSODescriptorArtifactResolutionServiceArtifact',
                },
            },

            # IDENTITY PROVIDER
            samlIDPSSODescriptor => {
                _nodes => [
                    qw(samlIDPSSODescriptorWantAuthnRequestsSigned
                      n:samlIDPSSODescriptorSingleSignOnService
                      n:samlIDPSSODescriptorSingleLogoutService
                      n:samlIDPSSODescriptorArtifactResolutionService)
                ],
                _help => 'default',

                samlIDPSSODescriptorWantAuthnRequestsSigned =>
                  'bool:/samlIDPSSODescriptorWantAuthnRequestsSigned',

                samlIDPSSODescriptorSingleSignOnService => {
                    _nodes => [
                        qw(samlIDPSSODescriptorSingleSignOnServiceHTTPRedirect
                          samlIDPSSODescriptorSingleSignOnServiceHTTPPost
                          samlIDPSSODescriptorSingleSignOnServiceHTTPArtifact
                          samlIDPSSODescriptorSingleSignOnServiceSOAP)
                    ],
                    _help => 'default',
                    samlIDPSSODescriptorSingleSignOnServiceHTTPRedirect =>
'samlService:/samlIDPSSODescriptorSingleSignOnServiceHTTPRedirect',
                    samlIDPSSODescriptorSingleSignOnServiceHTTPPost =>
'samlService:/samlIDPSSODescriptorSingleSignOnServiceHTTPPost',
                    samlIDPSSODescriptorSingleSignOnServiceHTTPArtifact =>
'samlService:/samlIDPSSODescriptorSingleSignOnServiceHTTPArtifact',
                    samlIDPSSODescriptorSingleSignOnServiceSOAP =>
'samlService:/samlIDPSSODescriptorSingleSignOnServiceSOAP',
                },

                samlIDPSSODescriptorSingleLogoutService => {
                    _nodes => [
                        qw(samlIDPSSODescriptorSingleLogoutServiceHTTPRedirect
                          samlIDPSSODescriptorSingleLogoutServiceHTTPPost
                          samlIDPSSODescriptorSingleLogoutServiceSOAP)
                    ],
                    _help => 'default',
                    samlIDPSSODescriptorSingleLogoutServiceHTTPRedirect =>
'samlService:/samlIDPSSODescriptorSingleLogoutServiceHTTPRedirect',
                    samlIDPSSODescriptorSingleLogoutServiceHTTPPost =>
'samlService:/samlIDPSSODescriptorSingleLogoutServiceHTTPPost',
                    samlIDPSSODescriptorSingleLogoutServiceSOAP =>
'samlService:/samlIDPSSODescriptorSingleLogoutServiceSOAP',
                },

                samlIDPSSODescriptorArtifactResolutionService => {
                    _nodes => [
                        qw(samlIDPSSODescriptorArtifactResolutionServiceArtifact)
                    ],
                    _help => 'default',
                    samlIDPSSODescriptorArtifactResolutionServiceArtifact =>
'samlAssertion:/samlIDPSSODescriptorArtifactResolutionServiceArtifact',
                },

            },

            # ATTRIBUTE AUTHORITY
            samlAttributeAuthorityDescriptor => {
                _nodes =>
                  [qw(n:samlAttributeAuthorityDescriptorAttributeService)],
                _help                                            => 'default',
                samlAttributeAuthorityDescriptorAttributeService => {
                    _nodes => [
                        qw(samlAttributeAuthorityDescriptorAttributeServiceSOAP)
                    ],
                    samlAttributeAuthorityDescriptorAttributeServiceSOAP =>
'samlService:/samlAttributeAuthorityDescriptorAttributeServiceSOAP',
                },
            },

            # ADVANCED SAML PARAMETERS
            samlAdvanced => {
                _nodes => [
                    qw(samlIdPResolveCookie samlMetadataForceUTF8 samlStorage cn:samlStorageOptions n:samlCommonDomainCookie)
                ],

                samlIdPResolveCookie  => 'text:/samlIdPResolveCookie',
                samlMetadataForceUTF8 => 'bool:/samlMetadataForceUTF8',
                samlStorage           => 'text:/samlStorage',
                samlStorageOptions    => {
                    _nodes => ['hash:/samlStorageOptions:default:btext'],
                    _js    => 'hashRoot',
                    _help  => 'default',
                },
                samlCommonDomainCookie => {
                    _nodes => [
                        qw(samlCommonDomainCookieActivation samlCommonDomainCookieDomain samlCommonDomainCookieReader samlCommonDomainCookieWriter)
                    ],
                    samlCommonDomainCookieActivation =>
                      'bool:/samlCommonDomainCookieActivation',
                    samlCommonDomainCookieDomain =>
                      'text:/samlCommonDomainCookieDomain',
                    samlCommonDomainCookieReader =>
                      'text:/samlCommonDomainCookieReader',
                    samlCommonDomainCookieWriter =>
                      'text:/samlCommonDomainCookieWriter',
                },

            },

        },
    };
}

## @method protected hashref testStruct()
# Returns the tests to do with the datas uploaded.
# @return hashref
sub testStruct {
    my $safe       = Safe->new();
    my $assignTest = qr/(?<=[^=<!>\|\?])=(?![=~])/;
    my $assignMsg  = 'containsAnAssignment';
    my $perlExpr   = sub {
        my $e = shift;
        $safe->reval( $e, 1 );
        return 1 unless ($@);
        return 1
          if ( $@ =~ /Global symbol "\$.*requires explicit package/ );
        return ( 1,
            "Function \"<b>$1</b>\" must be declared in customFunctions" )
          if ( $@ =~ /Bareword "(.*?)" not allowed while "strict subs"/ );
        return ( 0, $@ );
    };
    my $boolean = { test => qr/^(?:0|1)?$/, msgFail => 'Value must be 0 or 1' };
    my $integer =
      { test => qr/^(?:\d)+$/, msgFail => 'Value must be an integer' };
    my $pcre = sub {
        my $r = shift;
        my $q;
        eval { $q = qr/$r/ };
        return ( $@ ? ( 0, $@ ) : 1 );
    };
    my $testNotDefined = { test => sub { 1 }, msgFail => 'Ok' };
    my $lmAttrOrMacro = {
        test    => qr/^\$?[a-zA-Z_]\w*$/,
        msgFail => 'Value must be in the form $attr'
    };
    return {
        applicationList => {
            keyTest    => qr/^(\d*)?\w+$/,
            keyMsgFail => 'Bad category ID',
        },
        mailFrom             => $testNotDefined,
        trustedDomains       => $testNotDefined,
        exportedAttr         => $testNotDefined,
        mailSubject          => $testNotDefined,
        randomPasswordRegexp => $testNotDefined,
        passwordDB           => $testNotDefined,
        mailBody             => $testNotDefined,
        SMTPServer           => $testNotDefined,
        cookieExpiration     => $testNotDefined,
        notificationStorage  => $testNotDefined,
        mailUrl              => $testNotDefined,
        mailConfirmSubject   => $testNotDefined,
        mailConfirmBody      => $testNotDefined,
        authentication       => {
            test    => qr/^[a-zA-Z]+(?:\s[\w\s:;]+)?$/,
            msgFail => 'Bad module name',
        },
        cda        => $boolean,
        cookieName => {
            test    => qr/^[a-zA-Z]\w*$/,
            msgFail => 'Bad cookie name',
        },
        customFunctions => $testNotDefined,
        domain          => {
            test    => qr/^\.?[\w\-]+(?:\.[a-zA-Z][\w\-]*)*(?:\.[a-zA-Z]+)$/,
            msgFail => 'Bad domain',
        },
        exportedHeaders => {
            keyTest    => Lemonldap::NG::Common::Regexp::HOSTNAME,
            keyMsgFail => 'Bad virtual host name',
            '*'        => {
                keyTest    => qr/^\w([\w\-]*\w)?$/,
                keyMsgFail => 'Bad header name',
                test       => $perlExpr,
                warnTest   => sub {
                    my $e = shift;
                    return ( 0, $assignMsg ) if ( $e =~ $assignTest );
                    1;
                },
            },
        },
        exportedVars => {
            keyTest    => qr/^!?[a-zA-Z][\w-]*$/,
            keyMsgFail => 'Bad variable name',
            test       => qr/^[a-zA-Z][\w-]*$/,
            msgFail    => 'Bad attribute name',
        },
        globalStorage => {
            test    => qr/^[\w:]+$/,
            msgFail => 'Bad module name',
        },
        globalStorageOptions => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad parameter',
        },
        grantSessionRule => {
            test     => $perlExpr,
            warnTest => sub {
                my $e = shift;
                return ( 0, $assignMsg ) if ( $e =~ $assignTest );
                1;
            },
        },
        groups => {
            keyTest    => qr/^\w[\w-]*$/,
            keyMsgFail => 'Bad group name',
            test       => $perlExpr,
            warnTest   => sub {
                my $e = shift;
                return ( 0, $assignMsg ) if ( $e =~ $assignTest );
                1;
            },
        },
        https                  => $boolean,
        issuerDBSAMLActivation => $boolean,
        issuerDBSAMLPath       => $testNotDefined,
        issuerDBSAMLRule       => {
            test     => $perlExpr,
            warnTest => sub {
                my $e = shift;
                return ( 0, $assignMsg ) if ( $e =~ $assignTest );
                1;
            },
        },
        issuerDBCASActivation => $boolean,
        issuerDBCASPath       => $testNotDefined,
        issuerDBCASRule       => {
            test     => $perlExpr,
            warnTest => sub {
                my $e = shift;
                return ( 0, $assignMsg ) if ( $e =~ $assignTest );
                1;
            },
        },
        issuerDBOpenIDActivation => $boolean,
        issuerDBOpenIDPath       => $testNotDefined,
        issuerDBOpenIDRule       => {
            test     => $perlExpr,
            warnTest => sub {
                my $e = shift;
                return ( 0, $assignMsg ) if ( $e =~ $assignTest );
                1;
            },
        },
        key            => $testNotDefined,
        ldapAuthnLevel => $integer,
        ldapBase       => {
            test    => qr/^(?:\w+=.*|)$/,
            msgFail => 'Bad LDAP base',
        },
        ldapPort => {
            test    => qr/^\d*$/,
            msgFail => 'Bad port number'
        },
        ldapServer => {
            test => sub {
                my $l = shift;
                my @s = split( /[\s,]+/, $l );
                foreach my $s (@s) {
                    $s =~
/^(?:ldap(?:s|\+tls|i):\/\/)?\w[\w\-\.]+\w(?::\d{0,5})?\/?$/
                      or return ( 0, "Bad ldap uri \"$s\"" );
                }
                return 1;
            },
        },
        ldapPwdEnc => {
            test    => qr/^\w[\w\-]*\w$/,
            msgFail => 'Bad encoding',
        },
        ldapPpolicyControl           => $boolean,
        ldapSetPassword              => $boolean,
        ldapChangePasswordAsUser     => $boolean,
        mailLDAPFilter               => $testNotDefined,
        LDAPFilter                   => $testNotDefined,
        AuthLDAPFilter               => $testNotDefined,
        ldapGroupRecursive           => $boolean,
        ldapGroupObjectClass         => $testNotDefined,
        ldapGroupBase                => $testNotDefined,
        ldapGroupAttributeName       => $testNotDefined,
        ldapGroupAttributeNameUser   => $testNotDefined,
        ldapGroupAttributeNameSearch => $testNotDefined,
        ldapGroupAttributeNameGroup  => $testNotDefined,
        ldapTimeout                  => $testNotDefined,
        ldapVersion                  => $testNotDefined,
        ldapRaw                      => $testNotDefined,
        locationRules                => {
            keyTest => Lemonldap::NG::Common::Regexp::HOSTNAME,
            msgFail => 'Bad virtual host name',
            '*'     => {
                keyTest => $pcre,
                test    => sub {
                    my $e = shift;
                    return 1 if ( $e =~ /^(?:accept|deny|unprotect)$/i );
                    if ( $e =~ s/^logout(?:_(?:app_sso|app|sso))?\s*// ) {
                        return (
                            $e eq ''
                              or $e =~ Lemonldap::NG::Common::Regexp::HTTP_URI
                            ? 1
                            : ( 0, "bad url \"$e\"" )
                        );
                    }
                    return &$perlExpr($e);
                },
                warnTest => sub {
                    my $e = shift;
                    return ( 0, $assignMsg ) if ( $e =~ $assignTest );
                    1;
                },
            },
        },
        logoutServices => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad name',
        },
        macros => {
            keyTest    => qr/^[_a-zA-Z]\w*$/,
            keyMsgFail => 'Bad macro name',
            test       => $perlExpr,
            warnTest   => sub {
                my $e = shift;
                return ( 0, $assignMsg ) if ( $e =~ $assignTest );
                1;
            },
        },
        managerDn => {
            test    => qr/^(?:\w+=.*,\w+=.*)?$/,
            msgFail => 'Bad LDAP dn',
        },
        managerPassword => {
            test    => qr/^\S*$/,
            msgFail => 'Bad LDAP password',
        },
        notification        => $boolean,
        notificationStorage => {
            test    => qr/^[\w:]+$/,
            msgFail => 'Bad module name',
        },
        notificationStorageOptions => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad parameter',
        },
        notifyDeleted => $boolean,
        notifyOther   => $boolean,
        port          => {
            test    => qr/^\d*$/,
            msgFail => 'Bad port number'
        },
        portal => {
            test    => qr/^https?:\/\/\S+$/,
            msgFail => 'Bad portal value',
        },
        portalAutocomplete          => $boolean,
        portalDisplayAppslist       => { test => $perlExpr, },
        portalDisplayChangePassword => { test => $perlExpr, },
        portalDisplayLogout         => { test => $perlExpr, },
        portalDisplayResetPassword  => $boolean,
        portalForceAuthn            => $boolean,
        portalOpenLinkInNewWindow   => $boolean,
        portalParams                => $testNotDefined,
        portalRequireOldPassword    => $boolean,
        portalSkin                  => {
            test    => qr/\w+$/,
            msgFail => 'Bad skin name',
        },
        portalUserAttr => {
            test    => qr/\w+$/,
            msgFail => 'Unvalid session field',
        },
        post => {
            keyTest    => Lemonldap::NG::Common::Regexp::HOSTNAME,
            keyMsgFail => 'Bad virtual host name',
            '*'        => { keyTest => $pcre, },
        },
        protection => {
            keyTest => qr/^(?:none|authentificate|manager|)$/,
            msgFail => 'must be one of none authentificate manager',
        },
        securedCookie => {
            test    => qr/^(?:0|1|2)$/,
            msgFail => 'securedCookie must be 0, 1 or 2',
        },
        singleSession  => $boolean,
        singleIP       => $boolean,
        singleUserByIP => $boolean,
        Soap           => $boolean,
        storePassword  => $boolean,
        syslog         => {
            test => qw/^(?:auth|authpriv|daemon|local\d|user)?$/,
            msgFail =>
              'Only auth|authpriv|daemon|local0-7|user is allowed here',
        },
        timeout => {
            test    => qr/^\d*$/,
            msgFail => 'Bad number'
        },
        timeoutActivity => {
            test    => qr/^\d*$/,
            msgFail => 'Bad number',
        },
        userControl => {
            test    => $pcre,
            msgFail => 'Bad regular expression',
        },
        userDB => {
            test    => qr/^[a-zA-Z][\w\:]*$/,
            msgFail => 'Bad module name',
        },
        useRedirectOnError     => $boolean,
        useRedirectOnForbidden => $boolean,
        useXForwardedForIP     => $boolean,
        variables              => $testNotDefined,
        vhostOptions           => {
            keyTest    => Lemonldap::NG::Common::Regexp::HOSTNAME,
            keyMsgFail => 'Bad virtual host name',
            '*'        => {
                keyTest    => qr/^vhost(Port|Https)$/,
                keyMsgFail => 'Bad option name',
            },
        },
        whatToTrace => $lmAttrOrMacro,

        ########
        # SAML #
        ########
        saml                              => $testNotDefined,
        samlServiceMetaData               => $testNotDefined,
        samlIDPMetaDataExportedAttributes => {
            keyTest    => qr/^[a-zA-Z](?:[\w\-\.]*\w)?$/,
            keyMsgFail => 'Bad metadata name',
            '*'        => {
                keyTest    => qr/^\w([\w\-]*\w)?$/,
                keyMsgFail => 'Bad attribute name',
                test       => sub { return 1; },
            },
        },
        samlIDPMetaDataXML => {
            keyTest    => qr/^[a-zA-Z](?:[\w\-\.]*\w)?$/,
            keyMsgFail => 'Bad metadata name',
            '*'        => {
                test    => sub { return 1; },
                keyTest => sub { return 1; },
            },
        },
        samlIDPMetaDataOptions => {
            keyTest    => qr/^[a-zA-Z](?:[\w\-\.]*\w)?$/,
            keyMsgFail => 'Bad metadata name',
            '*'        => {
                test    => sub { return 1; },
                keyTest => sub { return 1; },
            },
        },
        samlSPMetaDataExportedAttributes => {
            keyTest    => qr/^[a-zA-Z](?:[\w\-\.]*\w)?$/,
            keyMsgFail => 'Bad metadata name',
            '*'        => {
                keyTest    => qr/^\w([\w\-]*\w)?$/,
                keyMsgFail => 'Bad attribute name',
                test       => sub { return 1; },
            },
        },
        samlSPMetaDataXML => {
            keyTest    => qr/^[a-zA-Z](?:[\w\-\.]*\w)?$/,
            keyMsgFail => 'Bad metadata name',
            '*'        => {
                test    => sub { return 1; },
                keyTest => sub { return 1; },
            },
        },
        samlSPMetaDataOptions => {
            keyTest    => qr/^[a-zA-Z](?:[\w\-\.]*\w)?$/,
            keyMsgFail => 'Bad metadata name',
            '*'        => {
                test    => sub { return 1; },
                keyTest => sub { return 1; },
            },
        },
        samlEntityID                                       => $testNotDefined,
        samlOrganizationDisplayName                        => $testNotDefined,
        samlOrganizationName                               => $testNotDefined,
        samlOrganizationURL                                => $testNotDefined,
        samlSPSSODescriptorAuthnRequestsSigned             => $boolean,
        samlSPSSODescriptorWantAssertionsSigned            => $boolean,
        samlSPSSODescriptorSingleLogoutServiceHTTPRedirect => $testNotDefined,
        samlSPSSODescriptorSingleLogoutServiceHTTPPost     => $testNotDefined,
        samlSPSSODescriptorSingleLogoutServiceSOAP         => $testNotDefined,
        samlSPSSODescriptorAssertionConsumerServiceHTTPArtifact =>
          $testNotDefined,
        samlSPSSODescriptorAssertionConsumerServiceHTTPPost  => $testNotDefined,
        samlSPSSODescriptorArtifactResolutionServiceArtifact => $testNotDefined,
        samlIDPSSODescriptorWantAuthnRequestsSigned          => $boolean,
        samlIDPSSODescriptorSingleSignOnServiceHTTPRedirect  => $testNotDefined,
        samlIDPSSODescriptorSingleSignOnServiceHTTPPost      => $testNotDefined,
        samlIDPSSODescriptorSingleSignOnServiceHTTPArtifact  => $testNotDefined,
        samlIDPSSODescriptorSingleSignOnServiceSOAP          => $testNotDefined,
        samlIDPSSODescriptorSingleLogoutServiceHTTPRedirect  => $testNotDefined,
        samlIDPSSODescriptorSingleLogoutServiceHTTPPost      => $testNotDefined,
        samlIDPSSODescriptorSingleLogoutServiceSOAP          => $testNotDefined,
        samlIDPSSODescriptorArtifactResolutionServiceArtifact =>
          $testNotDefined,
        samlNameIDFormatMapEmail                             => $testNotDefined,
        samlNameIDFormatMapX509                              => $testNotDefined,
        samlNameIDFormatMapWindows                           => $testNotDefined,
        samlNameIDFormatMapKerberos                          => $testNotDefined,
        samlAttributeAuthorityDescriptorAttributeServiceSOAP => $testNotDefined,
        samlServicePrivateKeySig                             => $testNotDefined,
        samlServicePrivateKeySigPwd                          => $testNotDefined,
        samlServicePublicKeySig                              => $testNotDefined,
        samlServicePrivateKeyEnc                             => $testNotDefined,
        samlServicePrivateKeyEncPwd                          => $testNotDefined,
        samlServicePublicKeyEnc                              => $testNotDefined,
        samlIdPResolveCookie                                 => $testNotDefined,
        samlMetadataForceUTF8                                => $boolean,
        samlStorage                                          => {
            test    => qr/^[\w:]*$/,
            msgFail => 'Bad module name',
        },
        samlStorageOptions => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad parameter',
        },
        samlAuthnContextMapPassword                   => $integer,
        samlAuthnContextMapPasswordProtectedTransport => $integer,
        samlAuthnContextMapTLSClient                  => $integer,
        samlAuthnContextMapKerberos                   => $integer,
        samlCommonDomainCookieActivation              => $boolean,
        samlCommonDomainCookieDomain                  => {
            test    => Lemonldap::NG::Common::Regexp::HOSTNAME,
            msgFail => 'Bad domain',
        },
        samlCommonDomainCookieReader => {
            test    => Lemonldap::NG::Common::Regexp::HTTP_URI,
            msgFail => 'Bad URI',
        },
        samlCommonDomainCookieWriter => {
            test    => Lemonldap::NG::Common::Regexp::HTTP_URI,
            msgFail => 'Bad URI',
        },

        # SSL
        SSLAuthnLevel => $integer,
        SSLVar        => $testNotDefined,
        SSLLDAPField  => $testNotDefined,
        SSLRequire    => $boolean,

        # CAS
        CAS_authnLevel => $integer,
        CAS_url        => {
            test    => Lemonldap::NG::Common::Regexp::HTTP_URI,
            msgFail => 'Bad CAS url',
        },
        CAS_CAFile          => $testNotDefined,
        CAS_renew           => $boolean,
        CAS_gateway         => $boolean,
        CAS_pgtFile         => $testNotDefined,
        CAS_proxiedServices => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad CAS proxied service identifier',
        },
        casAttr    => $testNotDefined,
        casStorage => {
            test    => qr/^[\w:]*$/,
            msgFail => 'Bad module name',
        },
        casStorageOptions => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad parameter',
        },

        # Remote
        remotePortal        => $testNotDefined,
        remoteGlobalStorage => {
            test    => qr/^[\w:]+$/,
            msgFail => 'Bad module name',
        },
        remoteGlobalStorageOptions => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad parameter',
        },

        # Proxy
        soapAuthService    => $testNotDefined,
        remoteCookieName   => $testNotDefined,
        soapSessionService => $testNotDefined,

        # OpenID
        openIdAuthnLevel => $integer,
        openIdSecret     => $testNotDefined,

        # Twitter
        twitterAuthnLevel => $integer,
        twitterKey        => $testNotDefined,
        twitterSecret     => $testNotDefined,
        twitterAppName    => $testNotDefined,

        # DBI
        dbiAuthnLevel       => $integer,
        dbiAuthChain        => $testNotDefined,
        dbiAuthUser         => $testNotDefined,
        dbiAuthPassword     => $testNotDefined,
        dbiUserChain        => $testNotDefined,
        dbiUserUser         => $testNotDefined,
        dbiUserPassword     => $testNotDefined,
        dbiAuthTable        => $testNotDefined,
        dbiUserTable        => $testNotDefined,
        dbiAuthLoginCol     => $testNotDefined,
        dbiAuthPasswordCol  => $testNotDefined,
        dbiAuthMailCol      => $testNotDefined,
        userPivot           => $testNotDefined,
        dbiAuthPasswordHash => $testNotDefined,

        # Apache
        apacheAuthnLevel => $integer,

        # Null
        nullAuthnLevel => $integer,

        # Choice
        authChoiceParams  => $testNotDefined,
        authChoiceModules => {
            keyTest    => qr/^(\d*)?\w+$/,
            keyMsgFail => 'Bad choice key',
        },

        # Zimbra
        zimbraPreAuthKey => $testNotDefined,
        zimbraAccountKey => $testNotDefined,
        zimbraBy         => $testNotDefined,
        zimbraUrl        => $testNotDefined,
        zimbraSsoUrl     => $testNotDefined,

        # Sympa
        sympaSecret  => $testNotDefined,
        sympaMailKey => $testNotDefined,

        # OpenID Issuer
        openIdIssuerSecret  => $testNotDefined,
        openIdAttr          => $testNotDefined,
        openIdSreg_fullname => $lmAttrOrMacro,
        openIdSreg_nickname => $lmAttrOrMacro,
        openIdSreg_language => $lmAttrOrMacro,
        openIdSreg_postcode => $lmAttrOrMacro,
        openIdSreg_timezone => $lmAttrOrMacro,
        openIdSreg_country  => $lmAttrOrMacro,
        openIdSreg_gender   => $lmAttrOrMacro,
        openIdSreg_email    => $lmAttrOrMacro,
        openIdSreg_dob      => $lmAttrOrMacro,

    };
}

## @method protected hashref defaultConf()
#@return Hashref of default values
sub defaultConf {
    my $self = shift;
    return {
        applicationList => {
            'default' => { catname => 'Default category', type => "category" }
        },
        authentication           => 'LDAP',
        authChoiceParam          => 'lmAuth',
        CAS_pgtFile              => '/tmp/pgt.txt',
        cda                      => '0',
        cookieName               => 'lemonldap',
        domain                   => 'example.com',
        globalStorage            => 'Apache::Session::File',
        https                    => '0',
        issuerDBSAMLActivation   => '0',
        issuerDBSAMLPath         => '^/saml/',
        issuerDBSAMLRule         => '1',
        issuerDBCASActivation    => '0',
        issuerDBCASPath          => '^/cas/',
        issuerDBCASRule          => '1',
        issuerDBOpenIDActivation => '0',
        issuerDBOpenIDPath       => '^/openidserver/',
        issuerDBOpenIDRule       => '1',
        key      => join( '', map { chr( int( rand(94) ) + 33 ) } ( 1 .. 16 ) ),
        ldapBase => 'dc=example,dc=com',
        ldapPort => '389',
        ldapPwdEnc                  => 'utf-8',
        ldapServer                  => 'localhost',
        ldapTimeout                 => '120',
        ldapVersion                 => '3',
        managerDn                   => '',
        managerPassword             => '',
        notification                => '0',
        notificationStorage         => 'File',
        notifyDeleted               => '1',
        notifyOther                 => '1',
        openIdSreg_fullname         => 'cn',
        openIdSreg_nickname         => 'uid',
        openIdSreg_timezone         => '_timezone',
        openIdSreg_email            => 'mail',
        portal                      => 'http://auth.example.com',
        portalSkin                  => 'pastel',
        portalUserAttr              => '_user',
        portalDisplayAppslist       => '1',
        portalDisplayChangePassword => '$_auth eq LDAP or $_auth eq DBI',
        portalDisplayLogout         => '1',
        portalDisplayResetPassword  => '1',
        protection                  => 'none',
        remoteGlobalStorage => 'Lemonldap::NG::Common::Apache::Session::SOAP',
        securedCookie       => '0',
        singleSession       => '0',
        singleIP            => '0',
        singleUserByIP      => '0',
        Soap                => '1',
        SSLRequired         => '0',
        storePassword       => '0',
        syslog              => '',
        timeout             => '72000',
        timeoutActivity     => '0',
        userControl         => '^[\w\.\-@]+$',
        userDB              => 'LDAP',
        passwordDB          => 'LDAP',
        useRedirectOnError  => '1',
        useRedirectOnForbidden => '0',
        useXForwardedForIP     => '0',
        vhostPort              => '-1',
        vhostHttps             => '-1',
        whatToTrace            => '$_whatToTrace',
        ########
        # SAML #
        ########
        samlEntityID                       => '#PORTAL#' . '/saml/metadata',
        samlOrganizationDisplayName        => 'Example',
        samlOrganizationName               => 'Example',
        samlOrganizationURL                => 'http://www.example.com',
        samlIDPMetaDataOptionsNameIDFormat => '',
        samlIDPMetaDataOptionsForceAuthn   => '0',
        samlIDPMetaDataOptionsIsPassive    => '0',
        samlIDPMetaDataOptionsAllowProxiedAuthn        => '1',
        samlIDPMetaDataOptionsSSOBinding               => '',
        samlIDPMetaDataOptionsSLOBinding               => '',
        samlIDPMetaDataOptionsResolutionRule           => '',
        samlIDPMetaDataOptionsAllowLoginFromIDP        => '1',
        samlIDPMetaDataOptionsAdaptSessionUtime        => '1',
        samlIDPMetaDataOptionsSignSSOMessage           => '1',
        samlIDPMetaDataOptionsCheckSSOMessageSignature => '1',
        samlIDPMetaDataOptionsSignSLOMessage           => '1',
        samlIDPMetaDataOptionsCheckSLOMessageSignature => '1',
        samlIDPMetaDataOptionsRequestedAuthnContext    => '',
        samlIDPMetaDataOptionsForceUTF8                => '0',
        samlIDPMetaDataOptionsEncryptionMode           => 'none',
        samlIDPMetaDataOptionsCheckConditions          => '1',
        samlSPMetaDataOptionsNameIDFormat              => '',
        samlSPMetaDataOptionsOneTimeUse                => '0',
        samlSPMetaDataOptionsSignSSOMessage            => '1',
        samlSPMetaDataOptionsCheckSSOMessageSignature  => '1',
        samlSPMetaDataOptionsSignSLOMessage            => '1',
        samlSPMetaDataOptionsCheckSLOMessageSignature  => '1',
        samlSPMetaDataOptionsEncryptionMode            => 'none',
        samlSPSSODescriptorAuthnRequestsSigned         => '1',
        samlSPSSODescriptorWantAssertionsSigned        => '1',
        samlSPSSODescriptorSingleLogoutServiceHTTPRedirect =>
          'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect;'
          . '#PORTAL#'
          . '/saml/proxySingleLogout;'
          . '#PORTAL#'
          . '/saml/proxySingleLogoutReturn',
        samlSPSSODescriptorSingleLogoutServiceHTTPPost =>
          'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST;'
          . '#PORTAL#'
          . '/saml/proxySingleLogout;'
          . '#PORTAL#'
          . '/saml/proxySingleLogoutReturn',
        samlSPSSODescriptorSingleLogoutServiceSOAP =>
          'urn:oasis:names:tc:SAML:2.0:bindings:SOAP;'
          . '#PORTAL#'
          . '/saml/proxySingleLogoutSOAP;',
        samlSPSSODescriptorAssertionConsumerServiceHTTPArtifact =>
          '1;0;urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact;'
          . '#PORTAL#'
          . '/saml/proxySingleSignOnArtifact',
        samlSPSSODescriptorAssertionConsumerServiceHTTPPost =>
          '0;1;urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST;'
          . '#PORTAL#'
          . '/saml/proxySingleSignOnPost',
        samlSPSSODescriptorArtifactResolutionServiceArtifact =>
          '1;0;urn:oasis:names:tc:SAML:2.0:bindings:SOAP;'
          . '#PORTAL#'
          . '/saml/artifact',
        samlIDPSSODescriptorWantAuthnRequestsSigned => '1',
        samlIDPSSODescriptorSingleSignOnServiceHTTPRedirect =>
          'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect;'
          . '#PORTAL#'
          . '/saml/singleSignOn;',
        samlIDPSSODescriptorSingleSignOnServiceHTTPPost =>
          'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST;'
          . '#PORTAL#'
          . '/saml/singleSignOn;',
        samlIDPSSODescriptorSingleSignOnServiceHTTPArtifact =>
          'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Artifact;'
          . '#PORTAL#'
          . '/saml/singleSignOnArtifact;',
        samlIDPSSODescriptorSingleSignOnServiceSOAP =>
          'urn:oasis:names:tc:SAML:2.0:bindings:SOAP;'
          . '#PORTAL#'
          . '/saml/singleSignOnSOAP;',
        samlIDPSSODescriptorSingleLogoutServiceHTTPRedirect =>
          'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect;'
          . '#PORTAL#'
          . '/saml/singleLogout;'
          . '#PORTAL#'
          . '/saml/singleLogoutReturn',
        samlIDPSSODescriptorSingleLogoutServiceHTTPPost =>
          'urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST;'
          . '#PORTAL#'
          . '/saml/singleLogout;'
          . '#PORTAL#'
          . '/saml/singleLogoutReturn',
        samlIDPSSODescriptorSingleLogoutServiceSOAP =>
          'urn:oasis:names:tc:SAML:2.0:bindings:SOAP;'
          . '#PORTAL#'
          . '/saml/singleLogoutSOAP;',
        samlIDPSSODescriptorArtifactResolutionServiceArtifact =>
          '1;0;urn:oasis:names:tc:SAML:2.0:bindings:SOAP;'
          . '#PORTAL#'
          . '/saml/artifact',
        samlNameIDFormatMapEmail    => 'mail',
        samlNameIDFormatMapX509     => 'mail',
        samlNameIDFormatMapWindows  => 'uid',
        samlNameIDFormatMapKerberos => 'uid',
        samlAttributeAuthorityDescriptorAttributeServiceSOAP =>
          'urn:oasis:names:tc:SAML:2.0:bindings:SOAP;'
          . '#PORTAL#'
          . '/saml/AA/SOAP;',
        samlServicePrivateKeySig                      => '',
        samlServicePrivateKeySigPwd                   => '',
        samlServicePublicKeySig                       => '',
        samlServicePrivateKeyEnc                      => '',
        samlServicePrivateKeyEncPwd                   => '',
        samlServicePublicKeyEnc                       => '',
        samlMetadataForceUTF8                         => 1,
        samlAuthnContextMapPassword                   => 2,
        samlAuthnContextMapPasswordProtectedTransport => 3,
        samlAuthnContextMapTLSClient                  => 5,
        samlAuthnContextMapKerberos                   => 4,
        samlCommonDomainCookieActivation              => 0,

        # Authentication levels
        ldapAuthnLevel    => 2,
        dbiAuthnLevel     => 2,
        SSLAuthnLevel     => 5,
        CAS_authnLevel    => 1,
        openIdAuthnLevel  => 1,
        twitterAuthnLevel => 1,
        apacheAuthnLevel  => 4,
        nullAuthnLevel    => 0,

    };
}

sub subDefaultConf {
    return {
        exportedHeaders => { 'Auth-User' => '$uid' },
        exportedVars => { cn => 'cn', mail => 'mail', uid => 'uid', },
        globalStorageOptions => {
            'Directory'     => '/var/lib/lemonldap-ng/sessions/',
            'LockDirectory' => '/var/lib/lemonldap-ng/sessions/lock/'
        },
        locationRules => { default => 'deny' },
        macros        => {
            '_whatToTrace' =>
'$_auth eq \'LDAP\' ? $uid : ($_auth eq \'SAML\' ? "$_user\\@$_idpConfKey" : "$_user\\@$_auth" )'
        },
        notificationStorageOptions =>
          { dirName => '/var/lib/lemonldap-ng/notifications', },
        post                       => { none => { expr => {}, }, },
        remoteGlobalStorageOptions => {
            'proxy' => 'https://remote/index.pl/sessions',
            'ns'    => 'https://remote/Lemonldap/NG/Common/CGI/SOAPService',
        },
        samlIDPMetaDataExportedAttributes => { 'uid' => '0;uid;;' },
        samlSPMetaDataExportedAttributes  => { 'uid' => '0;uid;;' },
    };
}

## @method hashref globalTests(hashref conf)
# Return a hash ref where keys are the names of the tests and values
# subroutines to execute.
#
# Subroutines can return one of the followings :
# - (1)         : everything is OK
# - (1,message) : OK with a warning
# - (0,message) : NOK
#
# Those subroutines can also modify configuration.
#
# @param $conf Configuration to test
# @return hash ref where keys are the names of the tests and values
sub globalTests {
    my ( $self, $conf ) = splice @_;
    return {

        # 1. CHECKS

        # TODO: better parsing using Common::Regexp

        # Check if portal is in domain
        portalIsInDomain => sub {
            return (
                1,
                (
                    index( $conf->{portal}, $conf->{domain} ) > 0
                    ? ''
                    : "Portal seems not to be in the domain $conf->{domain}"
                )
            );
        },

        # Check if virtual hosts are in the domain
        vhostInDomainOrCDA => sub {
            return 1 if ( $conf->{cda} );
            my @pb;
            foreach my $vh ( keys %{ $conf->{locationRules} } ) {
                push @pb, $vh unless ( index( $vh, $conf->{domain} ) >= 0 );
            }
            return (
                1,
                (
                    @pb
                    ? 'Virtual hosts '
                      . join( ', ', @pb )
                      . " are not in $conf->{domain} and cross-domain-authentication is not set"
                    : undef
                )
            );
        },

        # Check if "userDB" and "authentication" are consistent
        authAndUserDBConsistency => sub {
            foreach my $type (qw(OpenID SAML)) {
                return ( 0,
"\"$type\" can not be used as user database without using \"$type\" for authentication"
                  )
                  if (  $conf->{userDB} =~ /$type/
                    and $conf->{authentication} !~ /$type/ );
            }
            return 1;
        },

        # Check that OpenID macros exists
        checkAttrAndMacros => sub {
            my @tmp;
            foreach my $k ( keys %$conf ) {
                if ( $k =~
/^(?:openIdSreg_(?:(?:(?:full|nick)nam|languag|postcod|timezon)e|country|gender|email|dob)|whatToTrace)$/
                  )
                {
                    my $v = $conf->{$k};
                    $v =~ s/^$//;
                    next if ( $v =~ /^_/ );
                    push @tmp, $k
                      unless (
                        defined(
                            $conf->{exportedVars}->{$v}
                              or defined( $conf->{macros}->{$v} )
                        )
                      );
                }
            }
            return (
                1,
                (
                    @tmp
                    ? 'Values of parameters '
                      . join( ',', @tmp )
                      . ' are not defined in exported attributes or macros'
                    : ''
                )
            );
        },

        # 2. MODIFICATIONS

        # Remove unused and non-customized parameters
        compactModules => sub {
            foreach my $k ( keys %$conf ) {

                # No analysis for hash keys
                next if ( ref $conf->{$k} );

                # Check federation modules
                foreach my $type (qw(CAS OpenID SAML)) {

                    # Check authChoice values
                    my ( $authChoice, $userDBChoice ) = ( undef, undef );
                    if ( $conf->{authentication} eq 'Choice'
                        and defined $conf->{authChoiceModules} )
                    {
                        foreach ( keys %{ $conf->{authChoiceModules} } ) {
                            my ( $auth, $userDB, $passwordDB ) =
                              split( '|', $conf->{authChoiceModules}->{$_} );
                            $authChoice   = 1 if $auth   =~ /$type/i;
                            $userDBChoice = 1 if $userDB =~ /$type/i;
                        }
                    }

                    if (
                        (
                                $k =~ /^$type/i
                            and not( $conf->{"issuerDB${type}Activation"} )
                            and not( $conf->{authentication} =~ /$type/i )
                            and not( $conf->{userDB}         =~ /$type/i )
                            and not( defined $authChoice
                                or defined $userDBChoice )
                        )
                      )
                    {
                        my $v = $self->defaultConf()->{$k};
                        if ( defined($v) and $conf->{$k} eq $v ) {
                            delete $conf->{$k};
                        }
                    }
                }
                return 1;
            }
        },
    };
}

1;

