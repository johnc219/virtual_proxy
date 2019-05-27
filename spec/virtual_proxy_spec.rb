RSpec.describe VirtualProxy do
  it "has a version number" do
    expect(VirtualProxy::VERSION).not_to be nil
  end

  describe 'extended object' do
    let(:klass) do
      Class.new do
        extend VirtualProxy

        attr_reader :foo

        def initialize(foo)
          @foo = foo
        end
      end
    end

    describe '.build_lazy' do
      it 'creates a virtual proxy of the instance' do
        proxy = klass.build_lazy('hello')
        expect(proxy.foo).to eq('hello')
      end
    end
  end

  describe '.to' do
    it 'creates a virtual proxy' do
      expect(Array).not_to receive(:new)
      proxy = VirtualProxy.to { Array.new(1_000, 0) }
      expect(proxy).to be_a(VirtualProxy::Proxy)
    end
  end
end
