# @summary Ensures services are running
# @api private
class simp_authselect::service {
  assert_private()

  service { $::simp_authselect::service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true
  }
}
