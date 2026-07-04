# @summary TODO: Summary describing the SIMP class 'simp_authselect'
#
# @example Basic usage
#   include  'simp_authselect'
#
# @param custom_profile_name
#   String that must be provided in order to create a custom profile
#
# @param base_profile
#   Must be one of the enumerated values
#
# @param authselect_sections
#   An array that allows you to pass in any Pam::auth_sections for configuring the authselect
#   class
#
# @param use_authselect
#   Boolean set to simp_options::authselect, must be true to utilize the class
#
# @author simp
#
class simp_authselect (
  String        $custom_profile_name = 'simp',
  Enum[
    'sssd',
    'winbind',
    'nis',
    'minimal'
  ]             $base_profile        = 'sssd',
  Array[String] $authselect_sections = ['fingerprint', 'password', 'smartcard', 'system'],
  Boolean       $use_authselect      = simplib::lookup('simp_options::authselect', { 'default_value' => false }),
) {
  if $use_authselect {
    # Delegate authselect management to the pam module, which owns the
    # authselect profile and the 'authselect' class as of pam 9.0. This class
    # only translates its parameters into pam's authselect parameters; it must
    # NOT declare the 'authselect' class itself, or the catalog would contain a
    # duplicate Class[authselect] (pam declares it in pam::config).
    class { 'pam':
      use_authselect          => true,
      authselect_profile_name => $custom_profile_name,
      authselect_base_profile => $base_profile,
      auth_sections           => $authselect_sections,
    }
  } else {
    notify { 'Authselect is not enabled, doing nothing': }
  }
}
