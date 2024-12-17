require 'spec_helper'

describe 'simp_authselect' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default authselect values' do
        let(:pre_condition) do
          'class { "simp_options":
            authselect => true
          }'
        end
        let(:params) do
          {
            custom_profile_name: 'simp',
         base_profile: 'sssd',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('simp_authselect') }
        it { is_expected.to contain_class('pam') }
        it { is_expected.to contain_class('authselect') }
        # it { pp catalogue.resources }
        it { is_expected.to create_file('/etc/authselect/custom/simp/fingerprint-auth').with(content: "include 'simp/fingerprint-auth'") }
        it { is_expected.to create_file('/etc/authselect/custom/simp/smartcard-auth').with(content: "include 'simp/smartcard-auth'") }
        it { is_expected.to create_file('/etc/authselect/custom/simp/password-auth').with(content: "include 'simp/password-auth'") }
        it { is_expected.to create_file('/etc/authselect/custom/simp/system-auth').with(content: "include 'simp/system-auth'") }
      end

      context 'with single authselect value' do
        let(:pre_condition) do
          'class { "simp_options":
            authselect => true
          }'
        end
        let(:params) do
          {
            custom_profile_name: 'simp',
         base_profile: 'sssd',
         authselect_sections: ['smartcard'],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('simp_authselect') }
        it { is_expected.to contain_class('pam') }
        it { is_expected.to contain_class('authselect') }
        # it { pp catalogue.resources }
        it { is_expected.to create_file('/etc/authselect/custom/simp/smartcard-auth').with(content: "include 'simp/smartcard-auth'") }
      end

      context 'with authselect set to false' do
        let(:pre_condition) do
          'class { "simp_options":
            authselect => false
          }'
        end
        let(:params) do
          {
            custom_profile_name: 'simp',
         base_profile: 'sssd',
         authselect_sections: ['smartcard'],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('simp_authselect') }
        it { is_expected.not_to contain_class('pam') }
        it { is_expected.not_to contain_class('authselect') }
        it { is_expected.to contain_notify('Authselect is not enabled, doing nothing') }
      end
    end
  end
end
