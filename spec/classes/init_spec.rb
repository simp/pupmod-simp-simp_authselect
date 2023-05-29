require 'spec_helper'

describe 'simp_authselect' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts){ os_facts }

      context 'with default values' do
        let(:params) {{ 
          :custom_profile_name => 'simp',
          :base_profile => 'sssd',
        }}
        it { is_expected.to create_class('simp_authselect') }
        it { is_expected.to contain_class('pam') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('authselect') }
        #pam::auth_sections.each do |auth_section|
        it { is_expected.to create_file("custom/${custom_profile_name}").with({
            :owner => 'root',
            :group => 'root',
            :mode  => '0600'
          })
        }
      end

    end
  end
end
