# @summary Ensures that firewall rules are defined
# @api private
class simp_authselect::config::firewall {
  assert_private()

  # FIXME: ensure your module's firewall settings are defined here.
  iptables::listen::tcp_stateful { 'allow_simp_authselect_tcp_connections':
    trusted_nets => $::simp_authselect::trusted_nets,
    dports       => $::simp_authselect::tcp_listen_port
  }
}
