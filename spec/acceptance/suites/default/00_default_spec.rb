require 'spec_helper_acceptance'

test_name 'simp_authselect class'

describe 'simp_authselect class' do
  let(:manifest) do
    <<~EOS
      include 'simp_authselect'
    EOS
  end

  hosts.each do |host|
    context "on #{host}" do
      context 'with authselect enabled' do
        # simp_authselect gates on the simp_options::authselect catalyst and
        # delegates authselect management to pam
        let(:hieradata) { { 'simp_options::authselect' => true } }

        it 'applies with no errors' do
          set_hieradata_on(host, hieradata)
          apply_manifest_on(host, manifest, catch_failures: true)
        end

        it 'is idempotent' do
          apply_manifest_on(host, manifest, catch_changes: true)
        end

        it 'activates the simp authselect profile (delegated to pam)' do
          result = on(host, '/usr/bin/authselect current')
          expect(result.stdout).to match(%r{Profile ID:\s+(custom/)?simp})
        end
      end

      context 'with authselect disabled' do
        let(:hieradata) { { 'simp_options::authselect' => false } }

        # The disabled branch only emits an informational notify (not
        # idempotent by design), so only assert a clean apply here.
        it 'applies with no errors and does not manage authselect' do
          set_hieradata_on(host, hieradata)
          result = apply_manifest_on(host, manifest, catch_failures: true)
          expect(result.stdout).to include('Authselect is not enabled, doing nothing')
        end
      end
    end
  end
end
