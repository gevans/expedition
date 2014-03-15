require 'spec_helper'

describe Expedition do

  describe '.new' do

    subject(:client) do
      described_class.new('example.com', 12345)
    end

    let!(:mock_client) do
      double(Expedition::Client)
    end

    it 'returns new Expedition::Client with supplied host and port' do
      expect(Expedition::Client).to receive(:new).with('example.com', 12345).and_return(mock_client)
      expect(client).to eq(mock_client)
    end
  end

  describe '.client' do

    subject(:client) do
      Expedition.client
    end

    it 'returns an Expedition::Client' do
      expect(client).to be_an(Expedition::Client)
    end

    it 'returns the same instance' do
      expect(client.object_id).to eq(described_class.client.object_id)
    end
  end
end
