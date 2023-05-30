# @summary TODO: Summary describing the SIMP class 'simp_authselect'
#
# @example Basic usage
#   include  'simp_authselect'
#
# @param authselect_settings
#   A hash that allows you to pass in any settings for configuring the authselect
#   class
#
# @author simp
#
class simp_authselect (
  String $custom_profile_name                            = 'simp',
  Enum['sssd','winbind', 'nis', 'minimal'] $base_profile = 'sssd',
  Optional[Array[String]] $authselect_sections				 = undef 
  Boolean $use_authselect                                = simplib::lookup('simp_options::authselect', { 'default_value' => false })
) {
  if $use_authselect {
    include 'pam'
    $_authselect_sections = $authselect_sections ? {
      undef => simplib::lookup('pam::auth_sections', { 'default_value' => ['fingerprint', 'password', 'smartcard', 'system'] }), 
      default => $authselect_sections 
    }
    # Check against pam::auth_sections default is [ifingerprint', 'system', 'password', 'smartcard']
    # We need to iterate through this array and ONLY put the include in for the ones defined in that array
    # or the files we're referencing won't exist. I'm not entirely sure how to access pam::auth_sections variable
    # but if we can we need to so something like the following:
  
    $contents = $_authselect_sections.reduce({}) |$memo, $section| {
      $memo + {
        "${section}-auth" => {
          'content' => "include '${custom_profile_name}/${section}-auth'",
        },
      }
    }
  
    #instantiate the authselect class with the given authselect
    class { 'authselect':
      profile_manage => true,
      profile  => "custom/${custom_profile_name}",
      custom_profiles => {
        $custom_profile_name => {
          base_profile => $base_profile,
          contents => $contents,
        }
      },
    }
  } else {
      notify { "Authselect is not enabled, doing nothing": }
  }
}
