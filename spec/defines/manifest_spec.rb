# frozen_string_literal: true

require 'spec_helper'

describe 'k3s::manifest' do
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end
  MANIFEST_HASH_CONFIG = {
    'apiVersion' => 'v1',
    'kind': 'Pod',
    'metadata' => {}
  }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'with manifest content' do
        let(:title) { 'content' }
        let(:params) do
          { 'content' => <<-PUPPET
        ---
        apiVersion: v1
        kind: Pod
        metadata: {}'
        PUPPET
          }
        end

        it { is_expected.to compile }
      end

      context 'with manifest link' do
        let(:title) { 'linkasdasd' }
        let(:params) do
          { 'link' => "https://k8s.io/examples/pods/simple-pod.yaml" }
        end

        it { is_expected.to compile }
      end

      context 'with manifest with config as hash' do
        let(:title) { 'config-hash' }
        let(:params) do
          { 'config' => MANIFEST_HASH_CONFIG }
        end

        it { is_expected.to compile }
      end

      context 'with manifest with config as Array[hash]' do
        let(:title) { 'config-array-of-hash' }
        let(:params) do
          { 'config' => [MANIFEST_HASH_CONFIG, MANIFEST_HASH_CONFIG] }
        end

        it { is_expected.to compile }
      end
    end



  end
end
