require 'spec_helper'

describe 'simp_authselect' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts){ os_facts }

      context 'with default values' do
        let(:pre_condition){
          'class { "pam":
            auth_sections => ["fingerprint",] 
          }'
        }  
        let(:pre_condition){
          'class { "simp_options":
            authselect => true
          }'
        }
        let(:params) {{ 
          :custom_profile_name => 'simp',
          :base_profile => 'sssd',
          #:authselect_settings => {
          #  'fingerprint' => {
          #    :contents => 'include simp/fingerprint-auth' 
          #  },
          #},
        }}
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to create_class('simp_authselect') }
        it { is_expected.to contain_class('pam') }
        it { is_expected.to contain_class('authselect') }
        #it { pp catalogue.resources }
        #pam::auth_sections.each do |auth_section|
        it { is_expected.to create_file("/etc/authselect/custom/simp/fingerprint-auth") }
        #  path: '/etc/authselect/custom/simp/nsswitch.conf'
        #}) }
      end

    end
  end
end
