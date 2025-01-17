require 'spec_helper'

describe 'ironic::db' do
  shared_examples 'ironic::db' do
    context 'with default parameters' do
      it { should contain_class('ironic::deps') }

      it { should contain_oslo__db('ironic_config').with(
        :db_max_retries          => '<SERVICE DEFAULT>',
        :connection              => 'sqlite:////var/lib/ironic/ovs.sqlite',
        :connection_recycle_time => '<SERVICE DEFAULT>',
        :min_pool_size           => '<SERVICE DEFAULT>',
        :max_pool_size           => '<SERVICE DEFAULT>',
        :max_retries             => '<SERVICE DEFAULT>',
        :pool_timeout            => '<SERVICE DEFAULT>',
        :retry_interval          => '<SERVICE DEFAULT>',
        :max_overflow            => '<SERVICE DEFAULT>',
      )}
    end

    context 'with specific parameters' do
      let :params do
        {
          :database_connection              => 'mysql+pymysql://ironic:ironic@localhost/ironic',
          :database_connection_recycle_time => '3601',
          :database_min_pool_size           => '2',
          :database_max_pool_size           => '21',
          :database_max_retries             => '11',
          :database_pool_timeout            => '21',
          :database_max_overflow            => '21',
          :database_retry_interval          => '11',
          :database_db_max_retries          => '-1',
        }
      end

      it { should contain_class('ironic::deps') }

      it { should contain_oslo__db('ironic_config').with(
        :db_max_retries          => '-1',
        :connection              => 'mysql+pymysql://ironic:ironic@localhost/ironic',
        :connection_recycle_time => '3601',
        :min_pool_size           => '2',
        :max_pool_size           => '21',
        :max_retries             => '11',
        :retry_interval          => '11',
        :max_overflow            => '21',
        :pool_timeout            => '21',
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :concat_basedir => '/var/lib/puppet/concat',
          :fqdn           => 'some.host.tld',
        }))
      end

      it_behaves_like 'ironic::db'
    end
  end
end
