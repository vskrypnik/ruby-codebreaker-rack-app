class Cookie

  attr_accessor :key
  attr_accessor :value

  def initialize(key, value)
    @key, @value = key.to_s, value.to_s
  end

  def unpack
    data = Array.new
    data << @key
    data << @value
    data
  end

end