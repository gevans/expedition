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
          what_a: ['body']
        )
      end
    end
  end
end
