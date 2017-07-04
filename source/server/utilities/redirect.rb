require 'rack'

module Redirect

  def self.create(path, *cookies)
    Rack::Response.new do |response|
      cookies.each do |cookie|
        response.set_cookie *cookie.unpack
      end

      response.redirect normalize path
    end
  end

  def self.normalize(path)
    leading_slash?(path) ? path : "/#{path}"
  end

  def self.leading_slash?(path)
    path.chars.first == '/'
  end

  private_class_method :normalize
  private_class_method :leading_slash?

end