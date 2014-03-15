require 'spec_helper'

describe Expedition::Response do

  let(:original_data) do
    {
      'STATUS' => [
        {
          'STATUS' => 'S',
          'When' => 1394855182,
          'Code' => 17,
          'Msg' => 'GPU0',
          'Description' => 'sgminer 4.1.0'
        }
      ],
      'GPU' => [
        {
          'GPU' => 0,
          'Enabled' => 'Y',
          'Status' => 'Alive',
          'Temperature' => 72.0,
          'Fan Speed' => -1,
          'Fan Percent' => 100,
          'GPU Clock' => 947,
          'Memory Clock' => 1500,
          'GPU Voltage' => 0.0,
          'GPU Activity' => 100,
          'Powertune' => 30,
          'MHS av' => 0.9245,
          'MHS 5s' => 0.9228,
          'KHS av' => 924,
          'KHS 5s' => 923,
          'Accepted' => 1627,
          'Rejected' => 7,
          'Hardware Errors' => 3359,
          'Utility' => 0.5465,
          'Intensity' => '20',
          'Last Share Pool' => 0,
          'Last Share Time' => 1394735379,
          'Total MH' => 165125.5542,
          'Diff1 Work' => 836803,
          'Difficulty Accepted' => 833024.0,
          'Difficulty Rejected' => 3584.0,
          'Last Share Difficulty' => 512.0,
          'Last Valid Work' => 1394735379,
          'Device Hardware%' => 0.3998,
          'Device Rejected%' => 0.4283,
          'Device Elapsed' => 178612
        }
      ],
      'id' => 1
    }
  end

  let(:normalized_data) do
    {
      status: [
        {
          status: 'S',
          when: 1394855182,
          code: 17,
          msg: 'GPU0',
          description: 'sgminer 4.1.0'
        }
      ],
      gpu: [
        {
          gpu: 0,
          enabled: 'Y',
          status: 'Alive',
          temperature: 72.0,
          fan_speed: -1,
          fan_percent: 100,
          gpu_clock: 947,
          memory_clock: 1500,
          gpu_voltage: 0.0,
          gpu_activity: 100,
          powertune: 30,
          mhs_av: 0.9245,
          mhs_5s: 0.9228,
          khs_av: 924,
          khs_5s: 923,
          accepted: 1627,
          rejected: 7,
          hardware_errors: 3359,
          utility: 0.5465,
          intensity: '20',
          last_share_pool: 0,
          last_share_time: 1394735379,
          total_mh: 165125.5542,
          diff1_work: 836803,
          difficulty_accepted: 833024.0,
          difficulty_rejected: 3584.0,
          last_share_difficulty: 512.0,
          last_valid_work: 1394735379,
          device_hardware_percent: 0.3998,
          device_rejected_percent: 0.4283,
          device_elapsed: 178612
        }
      ],
      id: 1
    }
  end

  let(:response) do
    described_class.parse(original_data)
  end

  describe '.parse' do

    subject { response }

    it 'returns Expedition::Response' do
      expect(response).to be_an(Expedition::Response)
    end

    it 'initializes with normalized and original data' do
      expect(Expedition::Response).to receive(:new).with(normalized_data, original_data)
      response
    end

    it 'retains original hash' do
      expect(response.raw).to eq(original_data)
    end
  end

  describe '#status' do

    subject(:status) do
      response.status
    end

    it 'returns Expedition::Status' do
      expect(status).to be_an(Expedition::Status)
    end

    context 'when success' do

      before do
        original_data['STATUS'].first['STATUS'] = 'S'
      end

      it 'is success' do
        expect(status).to be_success

        expect(status).not_to be_info
        expect(status).not_to be_warning
        expect(status).not_to be_info
        expect(status).not_to be_info
        expect(status).not_to be_info
      end

      it 'is okay' do
        expect(status).to be_ok
      end
    end

    context 'when info' do

      before do
        original_data['STATUS'].first['STATUS'] = 'I'
      end

      it 'is info' do
        expect(status).to be_info

        expect(status).not_to be_success
        expect(status).not_to be_warning
        expect(status).not_to be_error
        expect(status).not_to be_fatal
      end

      it 'is okay' do
        expect(status).to be_ok
      end
    end

    context 'when warning' do

      before do
        original_data['STATUS'].first['STATUS'] = 'W'
      end

      it 'is warning' do
        expect(status).to be_warning

        expect(status).not_to be_success
        expect(status).not_to be_info
        expect(status).not_to be_error
        expect(status).not_to be_fatal
      end

      it 'is okay' do
        expect(status).to be_ok
      end
    end

    context 'when error' do

      before do
        original_data['STATUS'].first['STATUS'] = 'E'
      end

      it 'is error' do
        expect(status).to be_error

        expect(status).not_to be_success
        expect(status).not_to be_info
        expect(status).not_to be_warning
        expect(status).not_to be_fatal
      end

      it 'is not okay' do
        expect(status).not_to be_ok
      end
    end

    context 'when fatal' do

      before do
        original_data['STATUS'].first['STATUS'] = 'F'
      end

      it 'is fatal' do
        expect(status).to be_fatal

        expect(status).not_to be_success
        expect(status).not_to be_info
        expect(status).not_to be_warning
        expect(status).not_to be_error
      end

      it 'is not okay' do
        expect(status).not_to be_ok
      end
    end
  end

  %i(success? informational? warning? error? fatal? executed_at).each do |method_name|

    describe "##{method_name}" do

      it 'delegates to #status' do
        expect(response.status).to receive(method_name)
        response.send(method_name)
      end
    end
  end

  %i([] to_hash).each do |method_name|

    describe "##{method_name}" do

      it 'delegates to #body' do
        expect(response.body).to receive(method_name)
        response.send(method_name)
      end
    end
  end

  describe '#respond_to_missing?' do

    let(:response) do
      described_class.new(body, {})
    end

    context 'when #body has key' do

      let(:body) do
        {
          foo: 'blah'
        }
      end

      it 'returns true' do
        expect(response).to respond_to(:foo)
      end
    end

    context 'when #body does not have key' do

      let(:body) do
        {}
      end

      it 'returns false' do
        expect(response).not_to respond_to(:foo)
      end
    end
  end

  describe '#method_missing' do

    context 'when key in #body' do

      before do
        allow(response).to receive(:body).and_return(something: 'stuff')
      end

      it 'returns value' do
        expect(response.something).to eq('stuff')
      end
    end

    context 'when not key in #body' do

      it 'raises NoMethodError' do
        expect {
          response.bananas
        }.to raise_error(NoMethodError)
      end
    end
  end
end
