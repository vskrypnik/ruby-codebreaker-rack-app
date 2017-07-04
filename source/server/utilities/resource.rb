module Resource

  def self.view(name)
    resource 'views', name
  end

  def self.layout(name)
    resource 'layouts', name
  end

  def self.resource(folder, name)
    content "resources/#{folder}/#{name}.html.erb"
  end

  def self.content(path)
    File.exist?(path) ? File.read(path) : ''
  end

  private_class_method :content
  private_class_method :resource

end