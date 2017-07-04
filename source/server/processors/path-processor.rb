module PathProcessor

  def self.process(path)
    error if path.nil?
    error if path.strip.empty?
    normalize(path).to_sym
  end

  def self.normalize(path)
    # delete trailing and leading whitespaces
    path.strip!

    # path can contain only small letters
    path.downcase!

    # replace underscores and multiple
    # minuses by single minus
    path.gsub! /(_+|--+)/, '-'

    # delete symbols that are not small
    # english letters, digits or minuses
    # in the middle of the word
    path.gsub! /[^a-z0-9\-]/, ''

    # delete trailing and leading minuses
    path.gsub /(^\-+|\-+$)/, ''
  end

  def self.error
    raise ArgumentError.new 'Invalid path!'
  end

  private_class_method :error

end