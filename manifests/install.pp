# @summary Installs packages
# @api private
class simp_authselect::install {
  assert_private()

  package { $::simp_authselect::package_name:
    ensure => $::simp_authselect::package_ensure
  }
}
