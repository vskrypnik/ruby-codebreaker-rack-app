require './source/controller/processors/method-processor'

RSpec.describe MethodProcessor do

  let(:default) { [:get] }

  describe 'correct method' do
    it 'should return status true for all methods' do
      [:get, :post, :put, :patch, :delete, :update].each do |method|
        expect(MethodProcessor::correct? method).to eq true
        expect(MethodProcessor::correct? method.to_s).to eq true
      end
    end

    it 'should return false or nil for invalid methods' do
      [:'', :'abc', nil].each do |method|
        expect(MethodProcessor::correct? method).to be_falsey
        expect(MethodProcessor::correct? method.to_s).to be_falsey
      end
    end
  end

  describe 'process method' do
    it 'should return array with symbol :get' do
      [Array.new, [''], [nil], [:abc], ['abc']].each do |input|
        expect(MethodProcessor::process input).to eq default
      end
    end

    it 'should return array only with correct symbols' do
      result = [:get, :post, :delete]
      methods = [:get, :post, :delete, 'abc', '432', :abc]

      expect(MethodProcessor::process methods).to eq result
      expect(MethodProcessor::process methods.map &:to_s).to eq result
    end
  end

end