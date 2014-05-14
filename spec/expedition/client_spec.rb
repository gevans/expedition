require 'spec_helper'

describe Expedition::Client do

  describe '#initialize' do

    subject(:client) do
      described_class.new('example.com', 1234)
    end

    context 'by default' do

      subject(:client) do
        described_class.new
      end

      it 'sets host to "localhost"' do
        expect(client.host).to eq('localhost')
      end

      it 'sets port to 4028' do
        expect(client.port).to eq(4028)
      end
    end

    it 'initializes with supplied host and port' do
      expect(client.host).to eq('example.com')
      expect(client.port).to eq(1234)
    end
  end

  %i(send method_missing).each do |method_name|

    describe "##{method_name}" do

      subject(:client) do
        described_class.new
      end

      let(:socket) do
        double(TCPSocket)
      end

      before do
        allow(TCPSocket).to receive(:new).with(client.host, client.port).and_return(socket)
      end

      it 'sends supplied command and parameters to configured host and port' do
        expect(socket).to receive(:puts).with('{"command":"foo","parameter":"bar,baz"}')
        expect(socket).to receive(:gets).and_return(%/{}\x0/)
        client.__send__(method_name, 'foo', 'bar', 'baz')
      end

      it 'returns Expedition::Response with parsed body' do
        expect(socket).to receive(:puts).with('{"command":"foo","parameter":"bar,baz"}')
        expect(socket).to receive(:gets).and_return(%/{"what a":["body"]}\x0/)
        result = client.__send__(method_name, 'foo', 'bar', 'baz')
        expect(result.body).to eq(
          'what_a' => ['body']
        )
      end
    end
  end

  describe '#devices' do

    subject(:devices) do
      client.devices
    end

    let(:client) do
      described_class.new
    end

    let(:socket) do
      double(TCPSocket)
    end

    let(:response) do
      {
        'STATUS' => [
          {
            'STATUS' => 'S',
            'When' => 1399577859,
            'Code' => 69,
            'Msg' => 'Device Details',
            'Description' => 'sgminer 4.1.153'
          }
        ],
       'DEVDETAILS' => [
          {
            'DEVDETAILS' => 0,
            'Name' => 'GPU',
            'ID' => 0,
            'Driver' => 'opencl',
            'Kernel' => 'ckolivas',
            'Model' => 'AMD Radeon R9 200 Series',
            'Device Path' => ''
          },
          {
            'DEVDETAILS' => 1,
            'Name' => 'GPU',
            'ID' => 1,
            'Driver' => 'opencl',
            'Kernel' => 'ckolivas',
            'Model' => 'AMD Radeon R9 200 Series',
            'Device Path' => ''
          },
          {
            'DEVDETAILS' => 2,
            'Name' => 'GPU',
            'ID' => 2,
            'Driver' => 'opencl',
            'Kernel' => 'ckolivas',
            'Model' => 'AMD Radeon R9 200 Series',
            'Device Path' => ''
          }
        ],
       'id' => 1
      }.to_json
    end

    before do
      allow(TCPSocket).to receive(:new).with(client.host, client.port).and_return(socket)
      allow(socket).to receive(:puts)
      allow(socket).to receive(:gets).and_return(response)
    end

    specify do
      expect(devices.body).to eq([
        {
          'device_path' => '',
          'driver' => 'opencl',
          'id' => 0,
          'kernel' => 'ckolivas',
          'model' => 'AMD Radeon R9 200 Series',
          'variant' => 'gpu'
        },
        {
          'device_path' => '',
          'driver' => 'opencl',
          'id' => 1,
          'kernel' => 'ckolivas',
          'model' => 'AMD Radeon R9 200 Series',
          'variant' => 'gpu'
        },
        {
          'device_path' => '',
          'driver' => 'opencl',
          'id' => 2,
          'kernel' => 'ckolivas',
          'model' => 'AMD Radeon R9 200 Series',
          'variant' => 'gpu'
        }
      ])
    end
  end

  describe '#metrics' do

    subject(:metrics) do
      client.metrics
    end

    let(:client) do
      described_class.new
    end

    let(:socket) do
      double(TCPSocket)
    end

    let(:response) do
      {
        'STATUS' => [
          {
            'STATUS' => 'S',
            'When' => 1399419744,
            'Code' => 9,
            'Msg' => '1 GPU(s)',
            'Description' => 'sgminer 4.1.153'
          }
        ],
        'DEVS' => [
          {
            'Accepted' => 2,
            'Device Elapsed' => 11,
            'Device Hardware%' => 0.0,
            'Device Rejected%' => 0.0,
            'Diff1 Work' => 158,
            'Difficulty Accepted' => 256.0,
            'Difficulty Rejected' => 0.0,
            'Enabled' => 'Y',
            'Fan Percent' => 50,
            'Fan Speed' => -1,
            'GPU Activity' => 100,
            'GPU Clock' => 944,
            'GPU Voltage' => 0.0,
            'GPU' => 0,
            'Hardware Errors' => 0,
            'Intensity' => '0',
            'KHS 1s' => 923,
            'KHS av' => 915,
            'Last Share Difficulty' => 128.0,
            'Last Share Pool' => 0,
            'Last Share Time' => 1399419741,
            'Last Valid Work' => 1399419743,
            'MHS 1s' => 0.923,
            'MHS av' => 0.9148,
            'Memory Clock' => 1500,
            'Powertune' => 30,
            'Rejected' => 0,
            'Status' => 'Alive',
            'Temperature' => 68.0,
            'Total MH' => 10.1489,
            'Utility' => 10.8166
          }
        ],
        'id' => 1
      }.to_json
    end

    before do
      allow(TCPSocket).to receive(:new).with(client.host, client.port).and_return(socket)
      allow(socket).to receive(:puts)
      allow(socket).to receive(:gets).and_return(response)
    end

    specify do
      expect(metrics.body).to eq([
        'accepted' => 2,
        'device_elapsed' => 11,
        'device_hardware_percent' => 0.0,
        'device_rejected_percent' => 0.0,
        'diff1_work' => 158,
        'difficulty_accepted' => 256.0,
        'difficulty_rejected' => 0.0,
        'enabled' => true,
        'fan_percent' => 50,
        'fan_speed' => -1,
        'gpu' => 0,
        'gpu_activity' => 100,
        'gpu_clock' => 944,
        'gpu_voltage' => 0.0,
        'hardware_errors' => 0,
        'intensity' => '0',
        'khs' => 923,
        'khs_av' => 915,
        'last_share_difficulty' => 128.0,
        'last_share_pool' => 0,
        'last_share_time' => Time.utc(2014, 05, 06, 23, 42, 21),
        'last_valid_work' => Time.utc(2014, 05, 06, 23, 42, 23),
        'memory_clock' => 1500,
        'mhs' => 0.923,
        'mhs_av' => 0.9148,
        'powertune' => 30,
        'rejected' => 0,
        'status' => 'alive',
        'temperature' => 68.0,
        'total_mh' => 10.1489,
        'utility' => 10.8166
      ])
    end
  end

  describe '#pools' do

    subject(:pools) do
      client.pools
    end

    let(:client) do
      described_class.new
    end

    let(:socket) do
      double(TCPSocket)
    end

    let(:response) do
      {
        'STATUS' => [
          {
            'STATUS' => 'S',
            'When' => 1400026784,
            'Code' => 7,
            'Msg' => '1 Pool(s)',
            'Description' => 'sgminer 4.1.153'
          }
        ],
        'POOLS' => [
          {
            'POOL' => 0,
            'URL' => 'stratum+tcp://us-west2.multipool.us:3352',
            'Status' => 'Alive',
            'Priority' => 0,
            'Quota' => 1,
            'Long Poll' => 'N',
            'Getworks' => 31,
            'Accepted' => 413,
            'Rejected' => 0,
            'Works' => 206,
            'Discarded' => 1256,
            'Stale' => 0,
            'Get Failures' => 0,
            'Remote Failures' => 0,
            'User' => 'nobody',
            'Last Share Time' => 1400026781,
            'Diff1 Shares' => 52523,
            'Proxy Type' => '',
            'Proxy' => '',
            'Difficulty Accepted' => 52864.0,
            'Difficulty Rejected' => 0.0,
            'Difficulty Stale' => 0.0,
            'Last Share Difficulty' => 128.0,
            'Has Stratum' => true,
            'Stratum Active' => true,
            'Stratum URL' => 'us-west2.multipool.us',
            'Has GBT' => false,
            'Best Share' => 22673,
            'Pool Rejected%' => 0.0,
            'Pool Stale%' => 0.0
          }
        ],
        'id' => 1
      }.to_json
    end

    before do
      allow(TCPSocket).to receive(:new).with(client.host, client.port).and_return(socket)
      allow(socket).to receive(:puts)
      allow(socket).to receive(:gets).and_return(response)
    end

    specify do
      expect(pools.body).to eq([
        'pool' => 0,
        'url' => 'stratum+tcp://us-west2.multipool.us:3352',
        'status' => 'alive',
        'priority' => 0,
        'quota' => 1,
        'long_poll' => false,
        'getworks' => 31,
        'accepted' => 413,
        'rejected' => 0,
        'works' => 206,
        'discarded' => 1256,
        'stale' => 0,
        'get_failures' => 0,
        'remote_failures' => 0,
        'user' => 'nobody',
        'last_share_time' => Time.utc(2014, 05, 14, 0, 19, 41),
        'diff1_shares' => 52523,
        'proxy_type' => '',
        'proxy' => '',
        'difficulty_accepted' => 52864.0,
        'difficulty_rejected' => 0.0,
        'difficulty_stale' => 0.0,
        'last_share_difficulty' => 128.0,
        'has_stratum' => true,
        'stratum_active' => true,
        'stratum_url' => 'us-west2.multipool.us',
        'has_gbt' => false,
        'best_share' => 22673,
        'pool_rejected_percent' => 0.0,
        'pool_stale_percent' => 0.0
      ])
    end
  end
end
