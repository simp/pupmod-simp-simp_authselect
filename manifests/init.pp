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
    class { 'pam':
      auth_sections => $authselect_sections
    }

    $contents = $authselect_sections.reduce({}) |$memo, $section| {
      $memo + {
        "${section}-auth" => {
          'content' => "include '${custom_profile_name}/${section}-auth'",
        },
      }
    }

    #instantiate the authselect class with the given authselect_sections
    class { 'authselect':
      profile_manage  => true,
      profile         => "custom/${custom_profile_name}",
      custom_profiles => {
        $custom_profile_name => {
          base_profile => $base_profile,
          contents     => $contents,
        }
      },
    }
  } else {
    notify { 'Authselect is not enabled, doing nothing': }
  }
}
