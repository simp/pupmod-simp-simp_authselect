require 'spec_helper'

describe 'simp_authselect' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with default authselect values' do
        let(:pre_condition) do
          <<~END
            class { 'simp_options':
              authselect => true,
            }
          END
        end
        let(:params) do
          {
            custom_profile_name: 'simp',
            base_profile: 'sssd',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('simp_authselect') }
        # authselect management is delegated to pam (which owns the
        # 'authselect' class and builds the custom profile as of pam 9.0);
        # simp_authselect only translates its parameters into pam's.
        it {
          is_expected.to contain_class('pam').with(
            use_authselect: true,
            authselect_profile_name: 'simp',
            authselect_base_profile: 'sssd',
            auth_sections: ['fingerprint', 'password', 'smartcard', 'system'],
          )
        }
        # 'authselect' is still in the catalog, but declared by pam (not here),
        # so there is no duplicate Class[authselect]
        it { is_expected.to contain_class('authselect') }
      end

      context 'with single authselect value' do
        let(:pre_condition) do
          <<~END
            class { 'simp_options':
              authselect => true,
            }
          END
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
        it {
          is_expected.to contain_class('pam').with(
            use_authselect: true,
            authselect_profile_name: 'simp',
            authselect_base_profile: 'sssd',
            auth_sections: ['smartcard'],
          )
        }
        it { is_expected.to contain_class('authselect') }
      end

      context 'with authselect set to false' do
        let(:pre_condition) do
          <<~END
            class { 'simp_options':
              authselect => false,
            }
          END
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
