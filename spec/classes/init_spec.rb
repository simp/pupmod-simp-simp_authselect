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
      end
    end
  end
end
