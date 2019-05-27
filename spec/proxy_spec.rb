RSpec.describe VirtualProxy::Proxy do
  let(:klass) do
    Class.new do
      def foo
        'foo'
      end
    end
  end

  it 'delays object creation' do
    expect(klass).not_to receive(:new)
    described_class.new { klass.new }
  end

  it 'forwards messages to the proxy subject' do
    proxy = described_class.new { klass.new }
    expect(proxy.foo).to eq('foo')
  end

  describe '#__getobj__' do
    it 'returns the proxy subject' do
      subj = klass.new
      proxy = described_class.new { subj }
      expect(proxy.__getobj__).to be(subj)
    end
  end

  describe '#__setobj__' do
    it 'lazily sets the proxy subject' do
      subj1 = klass.new
      subj2 = klass.new

      proxy = described_class.new { subj1 }

      expect { proxy.__setobj__ { subj2 } }
        .to change { proxy.__getobj__ }.from(subj1).to(subj2)
    end
  end

  describe 'response set' do
    it 'includes messages in the subject response set' do
      proxy = described_class.new { [1, 2, 3] }
      expect(proxy).to respond_to(:push)
      expect(proxy.methods).to include(:push, :pop)
    end
  end
end
