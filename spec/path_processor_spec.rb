require './source/controller/processors/path-processor'

RSpec.describe PathProcessor do

  describe 'normalize method' do
    it 'should return symbol without "bad" symbols' do
      expect(PathProcessor::process 'path!?^&#$@*/').to eq :path
    end

    it 'should return symbol without trailing, leading and multiple minuses, underscores and whitespaces' do
      %w(-a a- -a- ----a----).each do |input|
        expect(PathProcessor::process input).to eq :a
      end

      %w(__path__for__ --path---for--).each do |input|
        expect(PathProcessor::process input).to eq :'path-for'
      end

      expect(PathProcessor::process 'path- for  ').to eq :'path-for'
    end
  end

  describe 'process method' do
    it 'should raise exception if nil or empty string' do
      [nil, '', '  '].each do |path|
        expect { PathProcessor::process path }
          .to raise_error ArgumentError
      end
    end

    it 'should return as symbols' do
      %w(home play start new).each do |path|
        expect(PathProcessor::process path).to eq path.to_sym
      end
    end
  end

end