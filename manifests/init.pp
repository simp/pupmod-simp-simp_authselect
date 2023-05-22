# @summary TODO: Summary describing the SIMP class 'simp_authselect'
#
# @example Basic usage
#   include  'simp_authselect'
#
# @param service_name
#   The name of the simp_authselect service
#
# @param package_name
#   The name of the simp_authselect package
#
# @param trusted_nets
#   A whitelist of subnets (in CIDR notation) permitted access
#
# @param auditing
#   If true, manage auditing for simp_authselect
#
# @param firewall
#   If true, manage firewall rules to acommodate simp_authselect
#
# @param logging
#   If true, manage logging configuration for simp_authselect
#
# @param pki
#   If true, manage PKI/PKE configuration for simp_authselect
#
# @param selinux
#   If true, manage selinux to permit simp_authselect
#
# @param tcpwrappers
#   If true, manage TCP wrappers configuration for simp_authselect
#
# @author simp
#
class simp_authselect (
  String                             $service_name       = 'simp_authselect',
  String                             $package_name       = 'simp_authselect',
  String[1]                          $package_ensure     = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' }),
  Simplib::Port                      $tcp_listen_port    = 9999,
  Simplib::Netlist                   $trusted_nets       = simplib::lookup('simp_options::trusted_nets', {'default_value' => ['127.0.0.1/32'] }),
  Variant[Boolean,Enum['simp']]      $pki         = simplib::lookup('simp_options::pki', { 'default_value'         => false }),
  Boolean                            $auditing    = simplib::lookup('simp_options::auditd', { 'default_value'      => false }),
  Variant[Boolean,Enum['firewalld']] $firewall    = simplib::lookup('simp_options::firewall', { 'default_value'    => false }),
  Boolean                            $logging     = simplib::lookup('simp_options::syslog', { 'default_value'      => false }),
  Boolean                            $selinux     = simplib::lookup('simp_options::selinux', { 'default_value'     => false }),
  Boolean                            $tcpwrappers = simplib::lookup('simp_options::tcpwrappers', { 'default_value' => false }),
) {

  simplib::assert_metadata($module_name)

  include 'simp_authselect::install'
  include 'simp_authselect::config'
  include 'simp_authselect::service'

  Class[ 'simp_authselect::install' ]
  -> Class[ 'simp_authselect::config' ]
  ~> Class[ 'simp_authselect::service' ]

  if $pki {
    include 'simp_authselect::config::pki'
    Class[ 'simp_authselect::config::pki' ]
    -> Class[ 'simp_authselect::service' ]
  }

  if $auditing {
    include 'simp_authselect::config::auditing'
    Class[ 'simp_authselect::config::auditing' ]
    -> Class[ 'simp_authselect::service' ]
  }

  if $firewall {
    include 'simp_authselect::config::firewall'
    Class[ 'simp_authselect::config::firewall' ]
    -> Class[ 'simp_authselect::service' ]
  }

  if $logging {
    include 'simp_authselect::config::logging'
    Class[ 'simp_authselect::config::logging' ]
    -> Class[ 'simp_authselect::service' ]
  }

  if $selinux {
    include 'simp_authselect::config::selinux'
    Class[ 'simp_authselect::config::selinux' ]
    -> Class[ 'simp_authselect::service' ]
  }

  if $tcpwrappers {
    include 'simp_authselect::config::tcpwrappers'
    Class[ 'simp_authselect::config::tcpwrappers' ]
    -> Class[ 'simp_authselect::service' ]
  }
}
