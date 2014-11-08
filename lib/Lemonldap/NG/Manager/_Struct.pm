## @file
# Manager tree structure and tests

## @class
# Manager tree structure and tests
package Lemonldap::NG::Manager::_Struct;

use strict;
use Lemonldap::NG::Common::Conf::SAML::Metadata;
use Lemonldap::NG::Common::Conf::Attributes;
use Lemonldap::NG::Common::Conf::SubAttributes;
use Lemonldap::NG::Common::Regexp;

our $VERSION = '1.4.2';

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
                        _js    => 'rulesRoot',
                        _help  => 'rules',
                    },
                    headers => {
                        _nodes => ["hash:/exportedHeaders/$k2"],
                        _js    => 'hashRoot',
                        _help  => 'headers',
                    },
                    post => {
                        _nodes => ["post:/post/$k2:post:post"],
                        _js    => 'postRoot',
                        _help  => 'post',
                    },
                    vhostOptions => {
                        _nodes => [
                            qw(vhostPort vhostHttps vhostMaintenance vhostAliases)
                        ],
                        vhostPort  => "int:/vhostOptions/$k2/vhostPort",
                        vhostHttps => "trool:/vhostOptions/$k2/vhostHttps",
                        vhostMaintenance =>
                          "bool:/vhostOptions/$k2/vhostMaintenance",
                        vhostAliases => "text:/vhostOptions/$k2/vhostAliases",
                        _help        => 'vhostOptions',
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
                        _js   => 'samlAttributeRoot',
                        _help => 'samlIDPExportedAttributes',
                    },

                    samlIDPMetaDataXML => "samlmetadata:/samlIDPMetaDataXML/$k2"
                      . ":samlIDPMetaDataXML:filearea",

                    samlIDPMetaDataOptions => {
                        _nodes => [
                            qw(samlIDPMetaDataOptionsResolutionRule samlIDPMetaDataOptionsAuthnRequest samlIDPMetaDataOptionsSession samlIDPMetaDataOptionsSignature samlIDPMetaDataOptionsBinding samlIDPMetaDataOptionsSecurity)
                        ],
                        _help => 'samlIDPOptions',

                        samlIDPMetaDataOptionsResolutionRule =>
"textarea:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsResolutionRule",

                        samlIDPMetaDataOptionsAuthnRequest => {
                            _nodes => [
                                qw(samlIDPMetaDataOptionsNameIDFormat samlIDPMetaDataOptionsForceAuthn samlIDPMetaDataOptionsIsPassive samlIDPMetaDataOptionsAllowProxiedAuthn samlIDPMetaDataOptionsAllowLoginFromIDP samlIDPMetaDataOptionsRequestedAuthnContext)
                            ],

                            samlIDPMetaDataOptionsNameIDFormat =>
"text:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsNameIDFormat"
                              . ":samlIDPOptions:nameIdFormatParams",
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
                              . ":samlIDPOptions:authnContextParams",
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
                              . ":samlIDPOptions:bindingParams",
                            samlIDPMetaDataOptionsSLOBinding =>
"text:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsSLOBinding"
                              . ":samlIDPOptions:bindingParams",

                        },

                        samlIDPMetaDataOptionsSecurity => {
                            _nodes => [
                                qw(samlIDPMetaDataOptionsEncryptionMode samlIDPMetaDataOptionsCheckConditions)
                            ],

                            samlIDPMetaDataOptionsEncryptionMode =>
"text:/samlIDPMetaDataOptions/$k2/samlIDPMetaDataOptionsEncryptionMode:samlIDPOptions:encryptionModeParams",
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
                        _js   => 'samlAttributeRoot',
                        _help => 'samlSPExportedAttributes',
                    },

                    samlSPMetaDataXML => "samlmetadata:/samlSPMetaDataXML/$k2"
                      . ":samlSPMetaDataXML:filearea",

                    samlSPMetaDataOptions => {
                        _nodes => [
                            qw(samlSPMetaDataOptionsAuthnResponse samlSPMetaDataOptionsSignature samlSPMetaDataOptionsSecurity)
                        ],
                        _help => 'samlSPOptions',

                        samlSPMetaDataOptionsAuthnResponse => {
                            _nodes => [
                                qw(samlSPMetaDataOptionsNameIDFormat samlSPMetaDataOptionsNameIDSessionKey samlSPMetaDataOptionsOneTimeUse samlSPMetaDataOptionsSessionNotOnOrAfterTimeout samlSPMetaDataOptionsNotOnOrAfterTimeout)
                            ],

                            samlSPMetaDataOptionsNameIDFormat =>
"text:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsNameIDFormat"
                              . ":samlSPOptions:nameIdFormatParams",
                            samlSPMetaDataOptionsNameIDSessionKey =>
"text:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsNameIDSessionKey",
                            samlSPMetaDataOptionsOneTimeUse =>
"bool:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsOneTimeUse",
                            samlSPMetaDataOptionsSessionNotOnOrAfterTimeout =>
"int:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsSessionNotOnOrAfterTimeout",
                            samlSPMetaDataOptionsNotOnOrAfterTimeout =>
"int:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsNotOnOrAfterTimeout",
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

                            _nodes => [
                                qw(samlSPMetaDataOptionsEncryptionMode samlSPMetaDataOptionsEnableIDPInitiatedURL)
                            ],

                            samlSPMetaDataOptionsEncryptionMode =>
"text:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsEncryptionMode:samlSPOptions:encryptionModeParams",
                            samlSPMetaDataOptionsEnableIDPInitiatedURL =>
"bool:/samlSPMetaDataOptions/$k2/samlSPMetaDataOptionsEnableIDPInitiatedURL",
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
                qw(n:portalParams n:authParams n:issuerParams n:logParams n:cookieParams n:sessionParams cn:reloadUrls n:advancedParams)
            ],
            _help => 'default',

            # PORTAL PARAMETERS
            portalParams => {
                _nodes => [
                    qw(portal n:portalMenu n:portalCustomization n:portalCaptcha)
                ],
                _help => 'portalParams',

                portal => 'text:/portal:portal:text',

                portalMenu => {
                    _nodes        => [qw(portalModules applicationList)],
                    _help         => 'menu',
                    portalModules => {
                        _nodes => [
                            qw(portalDisplayLogout portalDisplayChangePassword portalDisplayAppslist portalDisplayLoginHistory)
                        ],
                        portalDisplayLogout =>
                          'text:/portalDisplayLogout:menu:boolOrPerlExpr',
                        portalDisplayChangePassword =>
'text:/portalDisplayChangePassword:menu:boolOrPerlExpr',
                        portalDisplayAppslist =>
                          'text:/portalDisplayAppslist:menu:boolOrPerlExpr',
                        portalDisplayLoginHistory =>
                          'text:/portalDisplayLoginHistory:menu:boolOrPerlExpr',
                    },
                    applicationList => {
                        _nodes => [
'applicationlist:/applicationList:menuCatAndApp:applicationListCategory'
                        ],
                        _js   => 'applicationListCategoryRoot',
                        _help => 'menuCatAndApp',
                    },
                },

                portalCustomization => {
                    _nodes => [
                        qw(portalSkin cn:portalSkinRules portalButtons passwordManagement portalOther)
                    ],
                    _help => 'portalcustom',

                    portalSkin => 'text:/portalSkin:portalcustom:skinSelect',
                    portalSkinRules => {
                        _nodes => ['hash:/portalSkinRules:portalcustom:btext'],
                        _js    => 'hashRoot',
                        _help  => 'portalcustom',
                    },
                    portalButtons => {
                        _nodes => [
                            qw/portalCheckLogins portalDisplayResetPassword portalDisplayRegister/
                        ],
                        portalCheckLogins => 'bool:/portalCheckLogins',
                        portalDisplayResetPassword =>
                          'bool:/portalDisplayResetPassword',
                        portalDisplayRegister => 'bool:/portalDisplayRegister',
                    },
                    passwordManagement => {
                        _nodes => [
                            qw(portalRequireOldPassword hideOldPassword mailOnPasswordChange)
                        ],

                        portalRequireOldPassword =>
                          'bool:/portalRequireOldPassword',
                        hideOldPassword      => 'bool:/hideOldPassword',
                        mailOnPasswordChange => 'bool:/mailOnPasswordChange',
                    },
                    portalOther => {
                        _nodes => [
                            qw/portalAutocomplete portalUserAttr portalOpenLinkInNewWindow portalAntiFrame portalPingInterval/
                        ],

                        portalAutocomplete => 'bool:/portalAutocomplete',
                        portalUserAttr     => 'text:/portalUserAttr',
                        portalOpenLinkInNewWindow =>
                          'bool:/portalOpenLinkInNewWindow',
                        portalAntiFrame    => 'bool:/portalAntiFrame',
                        portalPingInterval => 'int:/portalPingInterval',
                    },
                },

                portalCaptcha => {
                    _nodes => [
                        qw(captcha_login_enabled captcha_mail_enabled captcha_register_enabled captcha_size captchaStorage cn:captchaStorageOptions)
                    ],
                    _help => 'captcha',

                    captcha_login_enabled => 'bool:/captcha_login_enabled',
                    captcha_mail_enabled  => 'bool:/captcha_mail_enabled',
                    captcha_register_enabled =>
                      'bool:/captcha_register_enabled',
                    captcha_size          => 'int:/captcha_size',
                    captchaStorage        => 'text:/captchaStorage',
                    captchaStorageOptions => {
                        _nodes => ['hash:/captchaStorageOptions:captcha:btext'],
                        _js    => 'hashRoot',
                        _help  => 'captcha',
                    },

                },
            },

            # AUTHENTICATION / USERDB / PASSWORDDB PARAMETERS
            authParams => {

               # Displayed nodes depend on authentication/userDB modules choosed
                _nodes => sub {
                    my $self = shift;
                    my $auth = $self->conf->{authentication};
                    my $udb  = $self->conf->{userDB};
                    my $pdb  = $self->conf->{passwordDB};
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
                            ad       => ['ldapParams'],
                            ldap     => ['ldapParams'],
                            ssl      => ['sslParams'],
                            cas      => ['casParams'],
                            radius   => ['radiusParams'],
                            remote   => ['remoteParams'],
                            proxy    => ['proxyParams'],
                            openid   => ['openIdParams'],
                            google   => ['googleParams'],
                            facebook => ['facebookParams'],
                            twitter  => ['twitterParams'],
                            webid    => ['webIDParams'],
                            dbi      => ['dbiParams'],
                            apache   => ['apacheParams'],
                            null     => ['nullParams'],
                            slave    => ['slaveParams'],
                            choice   => [
                                qw(ldapParams sslParams casParams radiusParams remoteParams proxyParams openIdParams googleParams facebookParams twitterParams webIDParams dbiParams apacheParams nullParams choiceParams slaveParams yubikeyParams browserIdParams demoParams)
                            ],
                            multi => [
                                qw(ldapParams sslParams casParams radiusParams remoteParams proxyParams openIdParams googleParams facebookParams twitterParams webIDParams dbiParams apacheParams nullParams choiceParams slaveParams yubikeyParams browserIdParams demoParams)
                            ],
                            yubikey   => ['yubikeyParams'],
                            browserid => ['browserIdParams'],
                            demo      => ['demoParams'],
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
                        qw(ldapAuthnLevel cn:ldapExportedVars n:ldapConnection n:ldapFilters n:ldapGroups n:ldapPassword)
                    ],
                    _help            => 'authLDAP',
                    ldapAuthnLevel   => 'int:/ldapAuthnLevel:authLDAPLevel:int',
                    ldapExportedVars => {
                        _nodes => ['hash:/ldapExportedVars:vars:btext'],
                        _js    => 'hashRoot',
                        _help  => 'authLDAP',
                    },
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
                        _help           => 'authLDAPConnection',
                    },

                    ldapFilters => {
                        _nodes =>
                          [qw(LDAPFilter AuthLDAPFilter mailLDAPFilter)],
                        LDAPFilter     => 'text:/LDAPFilter',
                        AuthLDAPFilter => 'text:/AuthLDAPFilter',
                        mailLDAPFilter => 'text:/mailLDAPFilter',
                        _help          => 'authLDAPFilters',
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
                        _help => 'authLDAPGroups',
                    },

                    ldapPassword => {
                        _nodes => [
                            qw(ldapPpolicyControl ldapSetPassword ldapChangePasswordAsUser ldapPwdEnc ldapUsePasswordResetAttribute ldapPasswordResetAttribute ldapPasswordResetAttributeValue)
                        ],
                        ldapPpolicyControl => 'bool:/ldapPpolicyControl',
                        ldapSetPassword    => 'bool:/ldapSetPassword',
                        ldapChangePasswordAsUser =>
                          'bool:/ldapChangePasswordAsUser',
                        ldapPwdEnc => 'text:/ldapPwdEnc',
                        ldapUsePasswordResetAttribute =>
                          'bool:/ldapUsePasswordResetAttribute',
                        ldapPasswordResetAttribute =>
                          'text:/ldapPasswordResetAttribute',
                        ldapPasswordResetAttributeValue =>
                          'text:/ldapPasswordResetAttributeValue',
                        _help => 'authLDAPPassword',
                    },

                },

                # SSL
                sslParams => {
                    _nodes        => [qw(SSLAuthnLevel SSLVar)],
                    _help         => 'authSSL',
                    SSLAuthnLevel => 'int:/SSLAuthnLevel',
                    SSLVar        => 'text:/SSLVar',
                },

                # CAS
                casParams => {
                    _nodes => [
                        qw(CAS_authnLevel CAS_url CAS_CAFile CAS_renew CAS_gateway CAS_pgtFile cn:CAS_proxiedServices)
                    ],
                    _help               => 'authCAS',
                    CAS_authnLevel      => 'int:/CAS_authnLevel',
                    CAS_url             => 'text:/CAS_url',
                    CAS_CAFile          => 'text:/CAS_CAFile',
                    CAS_renew           => 'bool:/CAS_renew',
                    CAS_gateway         => 'bool:/CAS_gateway',
                    CAS_pgtFile         => 'text:/CAS_pgtFile',
                    CAS_proxiedServices => {
                        _nodes => ['hash:/CAS_proxiedServices:authCAS:btext'],
                        _js    => 'hashRoot',
                        _help  => 'authCAS',
                    },

                },

                # Radius
                radiusParams => {
                    _nodes => [qw(radiusAuthnLevel radiusSecret radiusServer)],
                    _help  => 'authRadius',
                    radiusAuthnLevel => 'int:/radiusAuthnLevel',
                    radiusSecret     => 'text:/radiusSecret',
                    radiusServer     => 'text:/radiusServer',
                },

                # Remote
                remoteParams => {
                    _nodes => [
                        qw(remotePortal remoteCookieName remoteGlobalStorage cn:remoteGlobalStorageOptions)
                    ],
                    _help                      => 'authRemote',
                    remotePortal               => 'text:/remotePortal',
                    remoteCookieName           => 'text:/remoteCookieName',
                    remoteGlobalStorage        => 'text:/remoteGlobalStorage',
                    remoteGlobalStorageOptions => {
                        _nodes =>
                          ['hash:/remoteGlobalStorageOptions:authRemote:btext'],
                        _js   => 'hashRoot',
                        _help => 'authRemote',
                    },
                },

                # Proxy
                proxyParams => {
                    _nodes =>
                      [qw(soapAuthService remoteCookieName soapSessionService)],
                    _help              => 'authProxy',
                    soapAuthService    => 'text:/soapAuthService',
                    remoteCookieName   => 'text:/remoteCookieName',
                    soapSessionService => 'text:/soapSessionService',
                },

                # OpenID
                openIdParams => {
                    _nodes => [
                        qw(openIdAuthnLevel cn:openIdExportedVars openIdSecret openIdIDPList)
                    ],
                    _help              => 'authOpenID',
                    openIdAuthnLevel   => 'int:/openIdAuthnLevel',
                    openIdExportedVars => {
                        _nodes => ['hash:/openIdExportedVars:vars:btext'],
                        _js    => 'hashRoot',
                        _help  => 'authOpenID',
                    },
                    openIdSecret => 'text:/openIdSecret',
                    openIdIDPList =>
                      'text:/openIdIDPList:authOpenID:openididplist',
                },

                # Google
                googleParams => {
                    _nodes => [qw(googleAuthnLevel cn:googleExportedVars)],
                    _help  => 'authGoogle',
                    googleAuthnLevel   => 'int:/googleAuthnLevel',
                    googleExportedVars => {
                        _nodes => ['hash:/googleExportedVars:vars:btext'],
                        _js    => 'hashRoot',
                        _help  => 'authGoogle',
                    },
                },

                # Facebook
                facebookParams => {
                    _nodes => [
                        qw(facebookAuthnLevel cn:facebookExportedVars facebookAppId facebookAppSecret)
                    ],
                    _help                => 'authFacebook',
                    facebookAuthnLevel   => 'int:/facebookAuthnLevel',
                    facebookExportedVars => {
                        _nodes => ['hash:/facebookExportedVars:vars:btext'],
                        _js    => 'hashRoot',
                        _help  => 'authFacebook',
                    },
                    facebookAppId     => 'text:facebookAppId',
                    facebookAppSecret => 'text:facebookAppSecret',
                },

                # Twitter
                twitterParams => {
                    _nodes => [
                        qw(twitterAuthnLevel twitterKey twitterSecret twitterAppName)
                    ],
                    _help             => 'authTwitter',
                    twitterAuthnLevel => 'int:/twitterAuthnLevel',
                    twitterKey        => 'text:/twitterKey',
                    twitterSecret     => 'text:/twitterSecret',
                    twitterAppName    => 'text:/twitterAppName',
                },

                # WebID
                webIDParams => {
                    _nodes =>
                      [qw(webIDAuthnLevel cn:webIDExportedVars webIDWhitelist)],
                    _help             => 'authWebID',
                    webIDAuthnLevel   => 'int:webIDAuthnLevel',
                    webIDExportedVars => {
                        _nodes => ['hash:/webIDExportedVars:vars:btext'],
                        _js    => 'hashRoot',
                        _help  => 'authWebID',
                    },
                    webIDWhitelist => 'text:/webIDWhitelist',
                },

                # DBI
                dbiParams => {
                    _nodes => [
                        qw(dbiAuthnLevel cn:dbiExportedVars n:dbiConnection n:dbiSchema n:dbiPassword)
                    ],
                    _help           => 'authDBI',
                    dbiAuthnLevel   => 'int:/dbiAuthnLevel:authDBILevel:int',
                    dbiExportedVars => {
                        _nodes => ['hash:/dbiExportedVars:vars:btext'],
                        _js    => 'hashRoot',
                        _help  => 'authDBI',
                    },
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
                        _help => 'authDBIConnection',
                    },

                    dbiSchema => {
                        _nodes => [
                            qw(dbiAuthTable dbiUserTable dbiAuthLoginCol dbiAuthPasswordCol dbiPasswordMailCol userPivot)
                        ],
                        dbiAuthTable       => 'text:/dbiAuthTable',
                        dbiUserTable       => 'text:/dbiUserTable',
                        dbiAuthLoginCol    => 'text:/dbiAuthLoginCol',
                        dbiAuthPasswordCol => 'text:/dbiAuthPasswordCol',
                        dbiPasswordMailCol => 'text:/dbiPasswordMailCol',
                        userPivot          => 'text:/userPivot',
                        _help              => 'authDBISchema',
                    },

                    dbiPassword => {
                        _nodes              => [qw(dbiAuthPasswordHash)],
                        dbiAuthPasswordHash => 'text:/dbiAuthPasswordHash',
                        _help               => 'authDBIPassword',
                    },
                },

                # Apache
                apacheParams => {
                    _nodes           => [qw(apacheAuthnLevel)],
                    _help            => 'authApache',
                    apacheAuthnLevel => 'int:/apacheAuthnLevel',
                },

                # Null
                nullParams => {
                    _nodes         => [qw(nullAuthnLevel)],
                    _help          => 'authNull',
                    nullAuthnLevel => 'int:/nullAuthnLevel',
                },

                # Slave
                slaveParams => {
                    _nodes => [
                        qw(slaveAuthnLevel cn:slaveExportedVars slaveUserHeader slaveMasterIP)
                    ],
                    _help             => 'authSlave',
                    slaveAuthnLevel   => 'int:/slaveAuthnLevel',
                    slaveExportedVars => {
                        _nodes => ['hash:/slaveExportedVars:vars:btext'],
                        _js    => 'hashRoot',
                        _help  => 'authSlave',
                    },
                    slaveUserHeader => 'text:/slaveUserHeader',
                    slaveMasterIP   => 'text:/slaveMasterIP',
                },

                # Choice
                choiceParams => {
                    _nodes => [qw(authChoiceParam n:authChoiceModules)],
                    _help  => 'authChoice',
                    authChoiceParam   => 'text:/authChoiceParam',
                    authChoiceModules => {
                        _nodes =>
                          ['hash:/authChoiceModules:authChoice:authChoice'],
                        _js   => 'authChoiceRoot',
                        _help => 'authChoice',
                    },
                },

                # Yubikey
                yubikeyParams => {
                    _nodes => [
                        qw(yubikeyAuthnLevel yubikeyClientID yubikeySecretKey yubikeyPublicIDSize)
                    ],
                    _help               => 'authYubikey',
                    yubikeyAuthnLevel   => 'int:/yubikeyAuthnLevel',
                    yubikeyClientID     => 'text:/yubikeyClientID',
                    yubikeySecretKey    => 'text:/yubikeySecretKey',
                    yubikeyPublicIDSize => 'int:/yubikeyPublicIDSize',
                },

                # BrowserID
                browserIdParams => {
                    _nodes => [
                        qw(browserIdAuthnLevel browserIdAutoLogin browserIdVerificationURL browserIdSiteName browserIdSiteLogo browserIdBackgroundColor)
                    ],
                    _help               => 'authBrowserID',
                    browserIdAuthnLevel => 'int:/browserIdAuthnLevel',
                    browserIdAutoLogin  => 'bool:/browserIdAutoLogin',
                    browserIdVerificationURL =>
                      'text:/browserIdVerificationURL',
                    browserIdSiteName => 'text:/browserIdSiteName',
                    browserIdSiteLogo => 'text:/browserIdSiteLogo',
                    browserIdBackgroundColor =>
                      'text:/browserIdBackgroundColor',
                },

                # Demo
                demoParams => {
                    _nodes           => [qw(cn:demoExportedVars)],
                    _help            => 'authDemo',
                    demoExportedVars => {
                        _nodes => ['hash:/demoExportedVars:vars:btext'],
                        _js    => 'hashRoot',
                        _help  => 'authDemo',
                    },
                },

            },

            # ISSUERDB PARAMETERS
            issuerParams => {
                _nodes       => [qw(issuerDBSAML issuerDBCAS issuerDBOpenID)],
                _help        => 'issuerdb',
                issuerDBSAML => {
                    _nodes => [
                        qw(issuerDBSAMLActivation issuerDBSAMLPath issuerDBSAMLRule)
                    ],
                    _help                  => 'issuerdbSAML',
                    issuerDBSAMLActivation => 'bool:/issuerDBSAMLActivation',
                    issuerDBSAMLPath       => 'text:/issuerDBSAMLPath',
                    issuerDBSAMLRule =>
                      'text:/issuerDBSAMLRule:issuerdbSAML:boolOrPerlExpr',
                },
                issuerDBCAS => {
                    _nodes => [
                        qw(issuerDBCASActivation issuerDBCASPath issuerDBCASRule issuerDBCASOptions)
                    ],
                    _help                 => 'issuerdbCAS',
                    issuerDBCASActivation => 'bool:/issuerDBCASActivation',
                    issuerDBCASPath       => 'text:/issuerDBCASPath',
                    issuerDBCASRule =>
                      'text:/issuerDBCASRule:issuerdbCAS:boolOrPerlExpr',
                    issuerDBCASOptions => {
                        _nodes => [
                            qw(casAttr casAccessControlPolicy casStorage cn:casStorageOptions)
                        ],
                        casAttr => 'text:/casAttr',
                        casAccessControlPolicy =>
'select:/casAccessControlPolicy:issuerdbCAS:casAccessControlPolicyParams',
                        casStorage        => 'text:/casStorage',
                        casStorageOptions => {
                            _nodes =>
                              ['hash:/casStorageOptions:issuerDBCAS:btext'],
                            _js   => 'hashRoot',
                            _help => 'issuerdbCAS',
                        },
                    },
                },
                issuerDBOpenID => {
                    _nodes => [
                        qw(issuerDBOpenIDActivation issuerDBOpenIDPath issuerDBOpenIDRule n:issuerDBOpenIDOptions)
                    ],
                    _help => 'issuerdbOpenID',
                    issuerDBOpenIDActivation =>
                      'bool:/issuerDBOpenIDActivation',
                    issuerDBOpenIDPath => 'text:/issuerDBOpenIDPath',
                    issuerDBOpenIDRule =>
                      'text:/issuerDBOpenIDRule:issuerdbOpenID:boolOrPerlExpr',
                    issuerDBOpenIDOptions => {
                        _nodes => [
                            qw(openIdIssuerSecret openIdAttr openIdSPList n:openIdSreg)
                        ],
                        openIdIssuerSecret => 'text:/openIdIssuerSecret',
                        openIdAttr         => 'text:/openIdAttr',
                        openIdSPList =>
                          'text:/openIdSPList:issuerdbOpenID:openididplist',
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
                _nodes         => [qw(syslog trustedProxies whatToTrace)],
                _help          => 'logs',
                syslog         => 'text:/syslog',
                trustedProxies => 'text:/trustedProxies',
                whatToTrace    => 'text:/whatToTrace',
            },

            # COOKIE PARAMETERS
            cookieParams => {
                _nodes => [
                    qw(cookieName domain cda securedCookie httpOnly cookieExpiration)
                ],
                _help      => 'cookies',
                cookieName => 'text:/cookieName',
                domain     => 'text:/domain',
                cda        => 'bool:/cda',
                securedCookie =>
                  'select:/securedCookie:cookies:securedCookieValues',
                httpOnly         => 'bool:/httpOnly',
                cookieExpiration => 'text:/cookieExpiration',
            },

            # SESSIONS PARAMETERS
            sessionParams => {
                _nodes => [
                    qw(storePassword timeout timeoutActivity cn:grantSessionRules n:sessionStorage n:multipleSessions n:persistentSessions)
                ],
                _help => 'sessions',

                storePassword => 'bool:/storePassword',
                timeout       => 'int:/timeout',
                timeoutActivity =>
                  'text:/timeoutActivity:sessions:timeoutActivityParams',

                grantSessionRules => {
                    _nodes => [
'hash:/grantSessionRules:grantSessionRules:grantSessionRules'
                    ],
                    _js => 'grantSessionRulesRoot',
                },

                sessionStorage => {
                    _nodes => [
                        qw(globalStorage cn:globalStorageOptions localSessionStorage cn:localSessionStorageOptions)
                    ],
                    _help                => 'sessionsdb',
                    globalStorage        => 'text:/globalStorage',
                    globalStorageOptions => {
                        _nodes =>
                          ['hash:/globalStorageOptions:sessionsdb:btext'],
                        _js   => 'hashRoot',
                        _help => 'sessionsdb',
                    },
                    localSessionStorage        => 'text:/localSessionStorage',
                    localSessionStorageOptions => {
                        _nodes =>
                          ['hash:/localSessionStorageOptions:sessionsdb:btext'],
                        _js   => 'hashRoot',
                        _help => 'sessionsdb',
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

                persistentSessions => {
                    _nodes =>
                      [qw(persistentStorage cn:persistentStorageOptions)],
                    _help                    => 'sessionsdb',
                    persistentStorage        => 'text:/persistentStorage',
                    persistentStorageOptions => {
                        _nodes =>
                          ['hash:/persistentStorageOptions:sessionsdb:btext'],
                        _js   => 'hashRoot',
                        _help => 'sessionsdb',
                    },
                },

            },

            # RELOAD URLS
            reloadUrls => {
                _nodes => ['hash:/reloadUrls:reloadUrls:btext'],
                _js    => 'hashRoot',
                _help  => 'reloadUrls',
            },

            # OTHER PARAMETERS
            advancedParams => {
                _nodes => [
                    qw(customFunctions n:soap n:loginHistory n:notifications n:passwordManagement n:register n:security n:redirection n:portalRedirection n:specialHandlers cn:logoutServices)
                ],
                _help => 'advanced',

                customFunctions => 'text:/customFunctions:customfunctions:text',

                soap => {
                    _nodes       => [qw(Soap exportedAttr)],
                    Soap         => 'bool:/Soap',
                    exportedAttr => 'text:/exportedAttr',
                },

                loginHistory => {
                    _nodes => [
                        qw(loginHistoryEnabled successLoginNumber failedLoginNumber cn:sessionDataToRemember)
                    ],
                    _help                 => 'loginHistory',
                    loginHistoryEnabled   => 'bool:/loginHistoryEnabled',
                    successLoginNumber    => 'int:/successLoginNumber',
                    failedLoginNumber     => 'int:/failedLoginNumber',
                    sessionDataToRemember => {
                        _nodes =>
                          ['hash:/sessionDataToRemember:loginHistory:btext'],
                        _js => 'hashRoot',
                    },
                },

                notifications => {
                    _nodes => [
                        qw(notification notificationStorage cn:notificationStorageOptions notificationWildcard notificationXSLTfile)
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
                    notificationWildcard => 'text:/notificationWildcard',
                    notificationXSLTfile => 'text:/notificationXSLTfile',
                },

                passwordManagement => {
                    _nodes => [qw(SMTP mailHeaders mailContent mailOther)],
                    _help  => 'password',
                    SMTP   => {
                        _nodes => [qw(SMTPServer SMTPAuthUser SMTPAuthPass)],
                        SMTPServer   => 'text:/SMTPServer',
                        SMTPAuthUser => 'text:/SMTPAuthUser',
                        SMTPAuthPass => 'text:/SMTPAuthPass',
                    },
                    mailHeaders => {
                        _nodes      => [qw(mailFrom mailReplyTo mailCharset)],
                        mailFrom    => 'text:/mailFrom',
                        mailReplyTo => 'text:/mailReplyTo',
                        mailCharset => 'text:/mailCharset',
                    },
                    mailContent => {
                        _nodes => [
                            qw(mailSubject mailBody mailConfirmSubject mailConfirmBody)
                        ],
                        mailSubject        => 'text:/mailSubject',
                        mailBody           => 'textarea:/mailBody',
                        mailConfirmSubject => 'text:/mailConfirmSubject',
                        mailConfirmBody    => 'textarea:/mailConfirmBody',
                    },
                    mailOther => {
                        _nodes => [
                            qw(mailUrl randomPasswordRegexp mailTimeout mailSessionKey)
                        ],
                        mailUrl              => 'text:/mailUrl',
                        randomPasswordRegexp => 'text:/randomPasswordRegexp',
                        mailTimeout          => 'int:/mailTimeout',
                        mailSessionKey       => 'text:/mailSessionKey',
                    },
                },

                register => {
                    _nodes => [
                        qw/registerDB registerUrl registerTimeout registerConfirmSubject registerDoneSubject/
                    ],
                    _help       => 'register',
                    registerDB  => 'text:/registerDB:register:registerdbParams',
                    registerUrl => 'text:/registerUrl',
                    registerTimeout        => 'int:/registerTimeout',
                    registerConfirmSubject => 'text:/registerConfirmSubject',
                    registerDoneSubject    => 'text:/registerDoneSubject',
                },

                security => {
                    _nodes => [
                        qw(userControl portalForceAuthn key trustedDomains useSafeJail checkXSS)
                    ],
                    _help            => 'security',
                    userControl      => 'text:/userControl',
                    portalForceAuthn => 'bool:/portalForceAuthn',
                    key              => 'text:/key',
                    trustedDomains   => 'text:/trustedDomains',
                    useSafeJail      => 'bool:/useSafeJail',
                    checkXSS         => 'bool:/checkXSS',
                },

                redirection => {
                    _nodes => [
                        qw(https port useRedirectOnForbidden useRedirectOnError maintenance)
                    ],
                    _help                  => 'redirections',
                    https                  => 'bool:/https',
                    port                   => 'int:/port',
                    useRedirectOnForbidden => 'bool:/useRedirectOnForbidden',
                    useRedirectOnError     => 'bool:/useRedirectOnError',
                    maintenance            => 'bool:/maintenance',
                },

                portalRedirection => {
                    _nodes => [qw(jsRedirect)],
                    _help  => 'portalRedirections',
                    jsRedirect =>
                      'text:/jsRedirect:portalRedirections:boolOrPerlExpr',
                },

                specialHandlers => {
                    _nodes =>
                      [qw(zimbraHandler sympaHandler secureTokenHandler)],

                    # Zimbra
                    zimbraHandler => {
                        _nodes => [
                            qw(zimbraPreAuthKey zimbraAccountKey zimbraBy zimbraUrl zimbraSsoUrl)
                        ],
                        _help            => 'zimbra',
                        zimbraPreAuthKey => 'text:/zimbraPreAuthKey',
                        zimbraAccountKey => 'text:/zimbraAccountKey',
                        zimbraBy     => 'text:/zimbraBy:default:zimbraByParams',
                        zimbraUrl    => 'text:/zimbraUrl',
                        zimbraSsoUrl => 'text:/zimbraSsoUrl',
                    },

                    # Sympa
                    sympaHandler => {
                        _nodes       => [qw(sympaSecret sympaMailKey)],
                        _help        => 'sympa',
                        sympaSecret  => 'text:/sympaSecret',
                        sympaMailKey => 'text:/sympaMailKey',
                    },

                    # Secure Token
                    secureTokenHandler => {
                        _nodes => [
                            qw(secureTokenMemcachedServers secureTokenExpiration secureTokenAttribute secureTokenUrls secureTokenHeader secureTokenAllowOnError)
                        ],
                        _help => 'securetoken',
                        secureTokenMemcachedServers =>
                          'text:/secureTokenMemcachedServers',
                        secureTokenExpiration => 'int:/secureTokenExpiration',
                        secureTokenAttribute  => 'text:secureTokenAttribute',
                        secureTokenUrls       => 'text:/secureTokenUrls',
                        secureTokenHeader     => 'text:/secureTokenHeader',
                        secureTokenAllowOnError =>
                          'bool:/secureTokenAllowOnError',
                    },
                },

                logoutServices => {
                    _nodes => ['hash:/logoutServices:logoutforward:btext'],
                    _js    => 'hashRoot',
                    _help  => 'logoutforward',
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
                _help  => 'exportedVars',
            },

            # MACROS
            macros => {
                _nodes => ['hash:/macros:macros:btext'],
                _js    => 'hashRoot',
                _help  => 'macrosandgroups',
            },

            # GROUPS
            groups => {
                _nodes => ['hash:/groups:groups:btext'],
                _js    => 'hashRoot',
                _help  => 'macrosandgroups',
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
            _help   => 'samlIDP',
            _js     => 'samlIdpRoot',
        },

        samlSPMetaDataNode => {
            _nodes => [
'nhash:/samlSPMetaDataExportedAttributes:samlSPMetaDataNode:samlSpMetaData'
            ],
            _upload => [ '/samlSPMetaDataXML', '/samlSPMetaDataOptions' ],
            _help   => 'samlSP',
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
            _help => 'samlService',

            # GLOBAL INFORMATIONS
            samlEntityID => 'text:/samlEntityID:samlServiceEntityID:text',

            # SECURITY NODE
            samlServiceSecurity => {
                _nodes =>
                  [qw(n:samlServiceSecuritySig n:samlServiceSecurityEnc)],
                _help                  => 'samlServiceSecurity',
                samlServiceSecuritySig => {
                    _nodes => [
                        qw(samlServicePrivateKeySig
                          samlServicePrivateKeySigPwd
                          samlServicePublicKeySig)
                    ],
                    samlServicePrivateKeySig =>
                      'filearea:/samlServicePrivateKeySig',
                    samlServicePrivateKeySigPwd =>
                      'text:/samlServicePrivateKeySigPwd',
                    samlServicePublicKeySig =>
                      'filearea:/samlServicePublicKeySig',
                },
                samlServiceSecurityEnc => {
                    _nodes => [
                        qw(samlServicePrivateKeyEnc
                          samlServicePrivateKeyEncPwd
                          samlServicePublicKeyEnc)
                    ],
                    samlServicePrivateKeyEnc =>
                      'filearea:/samlServicePrivateKeyEnc',
                    samlServicePrivateKeyEncPwd =>
                      'text:/samlServicePrivateKeyEncPwd',
                    samlServicePublicKeyEnc =>
                      'filearea:/samlServicePublicKeyEnc',
                },
            },

            # NAMEID FORMAT MAP
            samlNameIDFormatMap => {
                _nodes => [
                    qw(samlNameIDFormatMapEmail samlNameIDFormatMapX509 samlNameIDFormatMapWindows samlNameIDFormatMapKerberos)
                ],
                _help                    => 'samlServiceNameIDFormats',
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
                _help => 'samlServiceAuthnContexts',
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
                _help => 'samlServiceOrganization',
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
                _help => 'samlServiceSP',

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
                    samlSPSSODescriptorAssertionConsumerServiceHTTPArtifact =>
'samlAssertion:/samlSPSSODescriptorAssertionConsumerServiceHTTPArtifact',
                    samlSPSSODescriptorAssertionConsumerServiceHTTPPost =>
'samlAssertion:/samlSPSSODescriptorAssertionConsumerServiceHTTPPost',
                },

                samlSPSSODescriptorArtifactResolutionService => {
                    _nodes => [
                        qw(samlSPSSODescriptorArtifactResolutionServiceArtifact)
                    ],
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
                _help => 'samlServiceIDP',

                samlIDPSSODescriptorWantAuthnRequestsSigned =>
                  'bool:/samlIDPSSODescriptorWantAuthnRequestsSigned',

                samlIDPSSODescriptorSingleSignOnService => {
                    _nodes => [
                        qw(samlIDPSSODescriptorSingleSignOnServiceHTTPRedirect
                          samlIDPSSODescriptorSingleSignOnServiceHTTPPost
                          samlIDPSSODescriptorSingleSignOnServiceHTTPArtifact
                          samlIDPSSODescriptorSingleSignOnServiceSOAP)
                    ],
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
                    samlIDPSSODescriptorArtifactResolutionServiceArtifact =>
'samlAssertion:/samlIDPSSODescriptorArtifactResolutionServiceArtifact',
                },

            },

            # ATTRIBUTE AUTHORITY
            samlAttributeAuthorityDescriptor => {
                _nodes =>
                  [qw(n:samlAttributeAuthorityDescriptorAttributeService)],
                _help => 'samlServiceAA',

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
                    qw(samlIdPResolveCookie samlMetadataForceUTF8 samlStorage cn:samlStorageOptions samlRelayStateTimeout samlUseQueryStringSpecific n:samlCommonDomainCookie)
                ],
                _help => 'samlServiceAdvanced',

                samlIdPResolveCookie  => 'text:/samlIdPResolveCookie',
                samlMetadataForceUTF8 => 'bool:/samlMetadataForceUTF8',
                samlStorage           => 'text:/samlStorage',
                samlStorageOptions    => {
                    _nodes =>
                      ['hash:/samlStorageOptions:samlServiceAdvanced:btext'],
                    _js   => 'hashRoot',
                    _help => 'samlServiceAdvanced',
                },
                samlRelayStateTimeout => 'int:/samlRelayStateTimeout',
                samlUseQueryStringSpecific =>
                  'bool:/samlUseQueryStringSpecific',
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
    my $safe     = Safe->new();
    my $perlExpr = sub {
        my $e = shift;
        $safe->reval( $e, 1 );
        return 1 unless ($@);
        return 1
          if ( $@ =~ /Global symbol "\$.*requires explicit package/ );
        return ( 1,
            "Function \"<b>$1$2</b>\" must be declared in customFunctions" )
          if ( $@ =~
/(?:Bareword "(\w+)" not allowed while "strict subs"|Undefined subroutine &(?:.*?::)?(\w+))/
          );
        return ( 0, $@ );
    };
    my $noAssign = sub {
        my $e          = shift;
        my $assignTest = qr/(?<=[^=<!>\|\?])=(?![=~])/;
        return $e =~ $assignTest ? ( 0, "contains an assignment" ) : 1;
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
    my $domainNameOrIp = sub {
        my $n = shift;
        return
             $n =~ /^(\d{1,3}\.){3}\d{1,3}$/
          || $n =~ Lemonldap::NG::Common::Regexp::HOSTNAME()
          || ( 0, 'Bad server name or IP' );
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
        mailCharset          => $testNotDefined,
        mailFrom             => $testNotDefined,
        mailReplyTo          => $testNotDefined,
        trustedDomains       => $testNotDefined,
        exportedAttr         => $testNotDefined,
        mailSubject          => $testNotDefined,
        randomPasswordRegexp => $testNotDefined,
        passwordDB           => $testNotDefined,
        mailBody             => $testNotDefined,
        SMTPServer           => $testNotDefined,
        SMTPAuthUser         => $testNotDefined,
        SMTPAuthPass         => $testNotDefined,
        cookieExpiration     => $testNotDefined,
        notificationStorage  => $testNotDefined,
        notificationWildcard => $testNotDefined,
        notificationXSLTfile => $testNotDefined,
        mailUrl              => $testNotDefined,
        mailTimeout          => $integer,
        mailSessionKey       => $testNotDefined,
        mailConfirmSubject   => $testNotDefined,
        mailConfirmBody      => $testNotDefined,
        authentication       => {
            test => sub {
                my $e = shift;

                # Do not check syntax for Multi
                return 1 if ( $e =~ /^multi/i );

                # Else, check the authentication module is valid
                return ( $e =~ qr/^[a-zA-Z]+$/ );
            },
            msgFail => 'Bad module name',
        },
        captcha_login_enabled    => $boolean,
        captcha_mail_enabled     => $boolean,
        captcha_register_enabled => $boolean,
        captcha_size             => $integer,
        captcha_data             => $testNotDefined,
        captcha_output           => $testNotDefined,
        captchaStorage           => {
            test    => qr/^[\w:]+$/,
            msgFail => 'Bad module name',
        },
        captchaStorageOptions => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad parameter',
        },
        cda        => $boolean,
        checkXSS   => $boolean,
        cookieName => {
            test    => qr/^[a-zA-Z]\w*$/,
            msgFail => 'Bad cookie name',
        },
        customFunctions => $testNotDefined,
        dbiExportedVars => {
            keyTest    => qr/^!?[a-zA-Z][\w-]*$/,
            keyMsgFail => 'Bad variable name',
            test       => qr/^[a-zA-Z][\w:\-]*$/,
            msgFail    => 'Bad attribute name',
        },
        demoExportedVars => {
            keyTest    => qr/^!?[a-zA-Z][\w-]*$/,
            keyMsgFail => 'Bad variable name',
            test       => qr/^[a-zA-Z][\w:\-]*$/,
            msgFail    => 'Bad attribute name',
        },
        domain => {
            test    => qr/^\.?[\w\-]+(?:\.[a-zA-Z][\w\-]*)*(?:\.[a-zA-Z]+)$/,
            msgFail => 'Bad domain',
        },
        exportedHeaders => {
            keyTest    => Lemonldap::NG::Common::Regexp::HOSTNAME(),
            keyMsgFail => 'Bad virtual host name',
            '*'        => {
                keyTest    => qr/^\w([\w\-]*\w)?$/,
                keyMsgFail => 'Bad header name',
                test       => $perlExpr,
                warnTest   => $noAssign,
            },
        },
        exportedVars => {
            keyTest    => qr/^!?[a-zA-Z][\w-]*$/,
            keyMsgFail => 'Bad variable name',
            test       => qr/^[a-zA-Z][\w:\-]*$/,
            msgFail    => 'Bad attribute name',
        },
        facebookExportedVars => {
            keyTest    => qr/^!?[a-zA-Z][\w-]*$/,
            keyMsgFail => 'Bad variable name',
            test       => qr/^[a-zA-Z][\w:\-]*$/,
            msgFail    => 'Bad attribute name',
        },
        failedLoginNumber => $integer,
        globalStorage     => {
            test    => qr/^[\w:]+$/,
            msgFail => 'Bad module name',
        },
        globalStorageOptions => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad parameter',
        },
        googleExportedVars => {
            keyTest    => qr/^!?[a-zA-Z][\w-]*$/,
            keyMsgFail => 'Bad variable name',
            test       => qr/^[a-zA-Z][\w:\-]*$/,
            msgFail    => 'Bad attribute name',
        },
        grantSessionRules => {
            keyTest     => $perlExpr,
            warnKeyTest => $noAssign,
        },
        groups => {
            keyTest    => qr/^\w[\w-]*$/,
            keyMsgFail => 'Bad group name',
            test       => $perlExpr,
            warnTest   => $noAssign,
        },
        httpOnly               => $boolean,
        https                  => $boolean,
        issuerDBSAMLActivation => $boolean,
        issuerDBSAMLPath       => $testNotDefined,
        issuerDBSAMLRule       => {
            test     => $perlExpr,
            warnTest => $noAssign,
        },
        issuerDBCASActivation => $boolean,
        issuerDBCASPath       => $testNotDefined,
        issuerDBCASRule       => {
            test     => $perlExpr,
            warnTest => $noAssign,
        },
        issuerDBOpenIDActivation => $boolean,
        issuerDBOpenIDPath       => $testNotDefined,
        issuerDBOpenIDRule       => {
            test     => $perlExpr,
            warnTest => $noAssign,
        },
        jsRedirect     => { test => $perlExpr, },
        key            => $testNotDefined,
        ldapAuthnLevel => $integer,
        ldapBase       => {
            test    => qr/^(?:\w+=.*|)$/,
            msgFail => 'Bad LDAP base',
        },
        ldapExportedVars => {
            keyTest    => qr/^!?[a-zA-Z][\w-]*$/,
            keyMsgFail => 'Bad variable name',
            test       => qr/^[a-zA-Z][\w:\-]*$/,
            msgFail    => 'Bad attribute name',
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
m{^(?:ldapi://[^/]*/?|\w[\w\-\.]*(?::\d{1,5})?|ldap(?:s|\+tls)?://\w[\w\-\.]*(?::\d{1,5})?/?.*)$}o
                      or return ( 0, "Bad ldap uri \"$s\"" );
                }
                return 1;
            },
        },
        ldapPwdEnc => {
            test    => qr/^\w[\w\-]*\w$/,
            msgFail => 'Bad encoding',
        },
        ldapUsePasswordResetAttribute   => $boolean,
        ldapPasswordResetAttribute      => $testNotDefined,
        ldapPasswordResetAttributeValue => $testNotDefined,
        ldapPpolicyControl              => $boolean,
        ldapSetPassword                 => $boolean,
        ldapChangePasswordAsUser        => $boolean,
        mailLDAPFilter                  => $testNotDefined,
        LDAPFilter                      => $testNotDefined,
        AuthLDAPFilter                  => $testNotDefined,
        ldapGroupRecursive              => $boolean,
        ldapGroupObjectClass            => $testNotDefined,
        ldapGroupBase                   => $testNotDefined,
        ldapGroupAttributeName          => $testNotDefined,
        ldapGroupAttributeNameUser      => $testNotDefined,
        ldapGroupAttributeNameSearch    => $testNotDefined,
        ldapGroupAttributeNameGroup     => $testNotDefined,
        ldapTimeout                     => $testNotDefined,
        ldapVersion                     => $testNotDefined,
        ldapRaw                         => $testNotDefined,
        localSessionStorage             => {
            test    => qr/^[\w:]+$/,
            msgFail => 'Bad module name',
        },
        localSessionStorageOptions => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad parameter',
        },
        locationRules => {
            keyTest => Lemonldap::NG::Common::Regexp::HOSTNAME(),
            msgFail => 'Bad virtual host name',
            '*'     => {
                keyTest => $pcre,
                test    => sub {
                    my $e = shift;
                    return 1 if ( $e =~ /^(?:accept|deny|unprotect|skip)$/i );
                    if ( $e =~ s/^logout(?:_(?:app_sso|app|sso))?\s*// ) {
                        return (
                            $e eq ''
                              or $e =~ Lemonldap::NG::Common::Regexp::HTTP_URI()
                            ? 1
                            : ( 0, "bad url \"$e\"" )
                        );
                    }
                    return &$perlExpr($e);
                },
                warnTest => $noAssign,
            },
        },
        loginHistoryEnabled => $boolean,
        logoutServices      => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad name',
        },
        macros => {
            keyTest    => qr/^[_a-zA-Z]\w*$/,
            keyMsgFail => 'Bad macro name',
            test       => $perlExpr,
            warnTest   => $noAssign,
        },
        mailOnPasswordChange => $boolean,
        maintenance          => $boolean,
        managerDn            => {
            test    => qr/^(?:\w+=.*)?$/,
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
        notifyDeleted      => $boolean,
        notifyOther        => $boolean,
        openIdExportedVars => {
            keyTest    => qr/^!?[a-zA-Z][\w-]*$/,
            keyMsgFail => 'Bad variable name',
            test       => qr/^[a-zA-Z][\w:\-]*$/,
            msgFail    => 'Bad attribute name',
        },
        persistentStorageOptions => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad parameter',
        },
        port => {
            test    => qr/^\d*$/,
            msgFail => 'Bad port number'
        },
        portal => {
            test    => qr/^https?:\/\/\S+$/,
            msgFail => 'Bad portal value',
        },
        portalAutocomplete          => $boolean,
        portalCheckLogins           => $boolean,
        portalDisplayLoginHistory   => { test => $perlExpr, },
        portalDisplayAppslist       => { test => $perlExpr, },
        portalDisplayChangePassword => { test => $perlExpr, },
        portalDisplayLogout         => { test => $perlExpr, },
        portalDisplayRegister       => $boolean,
        portalDisplayResetPassword  => $boolean,
        portalForceAuthn            => $boolean,
        portalOpenLinkInNewWindow   => $boolean,
        portalAntiFrame             => $boolean,
        portalParams                => $testNotDefined,
        portalPingInterval          => $integer,
        portalRequireOldPassword    => $boolean,
        hideOldPassword             => $boolean,
        portalSkin                  => {
            test    => qr/\w+$/,
            msgFail => 'Bad skin name',
        },
        portalSkinRules => {
            keyTest    => $perlExpr,
            keyMsgFail => 'Bad skin rule',
            test       => qr/\w+$/,
            msgFail    => 'Bad skin name',
        },
        portalUserAttr => {
            test    => qr/\w+$/,
            msgFail => 'Unvalid session field',
        },
        post => {
            keyTest    => Lemonldap::NG::Common::Regexp::HOSTNAME(),
            keyMsgFail => 'Bad virtual host name',
            '*'        => { keyTest => $pcre, },
        },
        protection => {
            keyTest => qr/^(?:none|authentificate|manager|)$/,
            msgFail => 'must be one of none authentificate manager',
        },
        registerConfirmSubject => $testNotDefined,
        registerDB             => $testNotDefined,
        registerDoneSubject    => $testNotDefined,
        registerTimeout        => $integer,
        registerUrl            => $testNotDefined,
        reloadUrls             => {
            keyTest => $domainNameOrIp,
            test    => Lemonldap::NG::Common::Regexp::HTTP_URI(),
            msgFail => 'Bad url'
        },
        securedCookie => {
            test    => qr/^(?:0|1|2|3)$/,
            msgFail => 'securedCookie must be 0, 1, 2 or 3',
        },
        sessionDataToRemember => {
            keyTest    => qr/^[\w-]+$/,
            keyMsgFail => 'Invalid session data',
        },
        singleSession     => $boolean,
        singleIP          => $boolean,
        singleUserByIP    => $boolean,
        slaveExportedVars => {
            keyTest    => qr/^!?[a-zA-Z][\w-]*$/,
            keyMsgFail => 'Bad variable name',
            test       => qr/^[a-zA-Z][\w:\-]*$/,
            msgFail    => 'Bad attribute name',
        },
        slaveMasterIP => {
            test =>
              qr/^(\s*((\d{1,3}\.){3}\d{1,3}\s+)*(\d{1,3}\.){3}\d{1,3})?\s*$/,
            msgFail => 'Bad parameter "master\'s IP" in Slave',
        },
        Soap               => $boolean,
        storePassword      => $boolean,
        successLoginNumber => $integer,
        syslog             => {
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
        trustedProxies => $testNotDefined,
        userControl    => {
            test    => $pcre,
            msgFail => 'Bad regular expression',
        },
        userDB => {
            test => sub {
                my $e = shift;

                # Do not check syntax for Multi
                return 1 if ( $e =~ /^multi/i );

                # Else, check the user module is valid
                return ( $e =~ qr/^[a-zA-Z]+$/ );
            },
            msgFail => 'Bad module name',
        },
        useRedirectOnError     => $boolean,
        useRedirectOnForbidden => $boolean,
        useSafeJail            => $boolean,
        variables              => $testNotDefined,
        vhostOptions           => {
            keyTest    => Lemonldap::NG::Common::Regexp::HOSTNAME(),
            keyMsgFail => 'Bad virtual host name',
            '*'        => {
                keyTest    => qr/^vhost(Port|Https|Maintenance|Aliases)$/,
                keyMsgFail => 'Bad option name',
            },
        },
        webIDExportedVars => {
            keyTest    => qr/^!?[a-zA-Z][\w-]*$/,
            keyMsgFail => 'Bad variable name',
            test       => qr/^[a-zA-Z][\w:\-]*$/,
            msgFail    => 'Bad attribute name',
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
            test    => Lemonldap::NG::Common::Regexp::HOSTNAME(),
            msgFail => 'Bad domain',
        },
        samlCommonDomainCookieReader => {
            test    => Lemonldap::NG::Common::Regexp::HTTP_URI(),
            msgFail => 'Bad URI',
        },
        samlCommonDomainCookieWriter => {
            test    => Lemonldap::NG::Common::Regexp::HTTP_URI(),
            msgFail => 'Bad URI',
        },
        samlRelayStateTimeout      => $integer,
        samlUseQueryStringSpecific => $boolean,

        # SSL
        SSLAuthnLevel => $integer,
        SSLVar        => $testNotDefined,

        # CAS
        CAS_authnLevel => $integer,
        CAS_url        => {
            test    => Lemonldap::NG::Common::Regexp::HTTP_URI(),
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
        casAttr                => $testNotDefined,
        casAccessControlPolicy => $testNotDefined,
        casStorage             => {
            test    => qr/^[\w:]*$/,
            msgFail => 'Bad module name',
        },
        casStorageOptions => {
            keyTest    => qr/^\w+$/,
            keyMsgFail => 'Bad parameter',
        },

        # Radius
        radiusAuthnLevel => $integer,
        radiusSecret     => $testNotDefined,
        radiusServer     => $testNotDefined,

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

        # Google
        googleAuthnLevel => $integer,

        # Facebook
        facebookAuthnLevel => $integer,
        facebookAppId      => $testNotDefined,
        facebookAppSecret  => $testNotDefined,

        # Twitter
        twitterAuthnLevel => $integer,
        twitterKey        => $testNotDefined,
        twitterSecret     => $testNotDefined,
        twitterAppName    => $testNotDefined,

        # WebID
        webIDAuthnLevel => $integer,
        webIDWhitelist  => $testNotDefined,

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
        dbiPasswordMailCol  => $testNotDefined,
        userPivot           => $testNotDefined,
        dbiAuthPasswordHash => $testNotDefined,

        # Apache
        apacheAuthnLevel => $integer,

        # Null
        nullAuthnLevel => $integer,

        # Slave
        slaveAuthnLevel => $integer,
        slaveUserHeader => $testNotDefined,

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

        # Yubikey
        yubikeyAuthnLevel   => $integer,
        yubikeyClientID     => $testNotDefined,
        yubikeySecretKey    => $testNotDefined,
        yubikeyPublicIDSize => $integer,

        # Secure Token
        secureTokenMemcachedServers => $testNotDefined,
        secureTokenExpiration       => $integer,
        secureTokenAttribute        => $testNotDefined,
        secureTokenUrls             => $testNotDefined,
        secureTokenHeader           => $testNotDefined,
        secureTokenAllowOnError     => $boolean,

        # BrowserID
        browserIdAuthnLevel      => $integer,
        browserIdAutoLogin       => $boolean,
        browserIdVerificationURL => $testNotDefined,
        browserIdSiteName        => $testNotDefined,
        browserIdSiteLogo        => $testNotDefined,
        browserIdBackgroundColor => $testNotDefined,
    };
}
## @method hashref subDefaultConf()
# Return the default values of subattributes
# @return hash ref { subattribute name => default value }
sub subDefaultConf {
    my ($self) = splice @_;
    my $h;

    my $confSubAttributes = Lemonldap::NG::Common::Conf::SubAttributes->new();
    my @attributes        = $confSubAttributes->meta()->get_attribute_list();

    foreach my $name (@attributes) {
        $h->{$name} = $confSubAttributes->$name;
    }

    return $h;
}

## @method hashref globalTests(hashref conf)
# Return a hash ref where keys are the names of the tests and values
# subroutines to execute.
#
# Subroutines can return one of the followings :
# -  (1)         : everything is OK
# -  (1,message) : OK with a warning
# -  (0,message) : NOK
# - (-1,message) : OK, but must be confirmed (ignored if confirm parameter is
# set
#
# Those subroutines can also modify configuration.
#
# @param $conf Configuration to test
# @return hash ref where keys are the names of the tests and values
sub globalTests {
    my ( $self, $conf ) = splice @_;
    return {

        # 1. CHECKS

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

        # Check if virtual host do not contain a port
        vhostWithPort => sub {
            my @pb;
            foreach my $vh ( keys %{ $conf->{locationRules} } ) {
                push @pb, $vh if ( $vh =~ /:/ );
            }
            if (@pb) {
                return ( 0,
                        'Virtual hosts '
                      . join( ', ', @pb )
                      . " contain a port, this is not allowed" );
            }
            else { return 1; }
        },

        # Force vhost to be lowercase
        vhostUpperCase => sub {
            my @pb;
            foreach my $vh ( keys %{ $conf->{locationRules} } ) {
                push @pb, $vh if ( $vh ne lc $vh );
            }
            if (@pb) {
                return ( 0,
                        'Virtual hosts '
                      . join( ', ', @pb )
                      . " must be in lower case" );
            }
            else { return 1; }
        },

        # Check if "userDB" and "authentication" are consistent
        authAndUserDBConsistency => sub {
            foreach my $type (qw(Facebook Google OpenID SAML WebID)) {
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
                    ? 'Values of parameter(s) "'
                      . join( ', ', @tmp )
                      . '" are not defined in exported attributes or macros'
                    : ''
                )
            );
        },

        # Test that variables are exported if Google is used as UserDB
        checkUserDBGoogleAXParams => sub {
            my @tmp;
            if ( $conf->{userDB} =~ /^Google/ ) {
                while ( my ( $k, $v ) = each %{ $conf->{exportedVars} } ) {
                    if ( $v !~ Lemonldap::NG::Common::Regexp::GOOGLEAXATTR() ) {
                        push @tmp, $v;
                    }
                }
            }
            return (
                1,
                (
                    @tmp
                    ? 'Values of parameter(s) "'
                      . join( ', ', @tmp )
                      . '" are not exported by Google'
                    : ''
                )
            );
        },

        # Test that variables are exported if OpenID is used as UserDB
        checkUserDBOpenIDParams => sub {
            my @tmp;
            if ( $conf->{userDB} =~ /^OpenID/ ) {
                while ( my ( $k, $v ) = each %{ $conf->{exportedVars} } ) {
                    if ( $v !~ Lemonldap::NG::Common::Regexp::OPENIDSREGATTR() )
                    {
                        push @tmp, $v;
                    }
                }
            }
            return (
                1,
                (
                    @tmp
                    ? 'Values of parameter(s) "'
                      . join( ', ', @tmp )
                      . '" are not exported by OpenID SREG'
                    : ''
                )
            );
        },

        # Try to use Apache::Session module
        testApacheSession => sub {
            my ( $id, %h );
            return 1
              if ( $Lemonldap::NG::Handler::_CGI::tsv->{globalStorage} eq
                   $conf->{globalStorage}
                or $conf->{globalStorage} eq
                'Lemonldap::NG::Common::Apache::Session::SOAP' );
            eval "use $conf->{globalStorage}";
            return ( -1, "Unknown package $conf->{globalStorage}" ) if ($@);
            eval {
                tie %h, $conf->{globalStorage}, undef,
                  $conf->{globalStorageOptions};
            };
            return ( -1, "Unable to create a session ($@)" )
              if ( $@ or not tied(%h) );
            eval {
                $h{a} = 1;
                $id = $h{_session_id} or return ( -1, 'No _session_id' );
                untie(%h);
                tie %h, $conf->{globalStorage}, $id,
                  $conf->{globalStorageOptions};
            };
            return ( -1, "Unable to insert datas ($@)" ) if ($@);
            return ( -1, "Unable to recover data stored" )
              unless ( $h{a} == 1 );
            eval { tied(%h)->delete; };
            return ( -1, "Unable to delete session ($@)" ) if ($@);
            my $gc = $Lemonldap::NG::Handler::_CGI::tsv->{globalStorage};
            return ( -1,
'All sessions may be lost and you <b>must</b> restart all your Apache servers'
            ) if ( $conf->{globalStorage} ne $gc );
            return 1;
        },

        # Warn if cookie name has changed
        cookieNameChanged => sub {
            return (
                1,
                (
                    $Lemonldap::NG::Handler::_CGI::tsv->{cookieName} ne
                      $conf->{cookieName}
                    ? 'Cookie name has changed, you <b>must</b> restart all your Apache servers'
                    : ()
                )
            );
        },

        # Warn if manager seems to be unprotected
        managerProtection => sub {
            return (
                1,
                (
                    $conf->{cfgAuthor} eq 'anonymous'
                    ? 'Your manager seems to be unprotected'
                    : ''
                )
            );
        },

        # Test SMTP connection and authentication
        smtpConnectionAuthentication => sub {

            # Skip test if no SMTP configuration
            return 1 unless ( $conf->{SMTPServer} );

            # Use SMTP
            eval "use Net::SMTP";
            return ( 0, "Net::SMTP module is required to use SMTP server" )
              if ($@);

            # Create SMTP object
            my $smtp = Net::SMTP->new( $conf->{SMTPServer} );
            return ( 0,
                "SMTP connection to " . $conf->{SMTPServer} . " failed" )
              unless ($smtp);

            # Skip other tests if no authentication
            return 1
              unless ( $conf->{SMTPAuthUser} and $conf->{SMTPAuthPass} );

            # Try authentication
            return ( 0, "SMTP authentication failed" )
              unless $smtp->auth( $conf->{SMTPAuthUser},
                $conf->{SMTPAuthPass} );

            # Return
            return 1;
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
                        my $confAttributes =
                          Lemonldap::NG::Common::Conf::Attributes->new();
                        my $v = $confAttributes->$k;
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

