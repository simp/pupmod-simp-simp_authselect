require 'spec_helper_acceptance'

test_name 'simp_authselect class'

describe 'simp_authselect class' do
  let(:manifest) do
    <<-EOS
      class { 'simp_authselect': }
    EOS
  end

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works with no errors' do
      apply_manifest(manifest, catch_failures: true)
    end

    it 'is idempotent' do
      apply_manifest(manifest, catch_changes: true)
    end

    describe package('simp_authselect') do
      it { is_expected.to be_installed }
    end

    describe service('simp_authselect') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
