require './source/template-context'
require './source/server/utilities/resource'

module Render

  def self.render(layout, view, context)
    context = Context.new unless context
    result = render_view view, context

    unless layout.empty?
      context = Context.new result
      result = render_layout layout, context
    end

    result
  end

  def self.process(data, context)
    binding = context.binding
    ERB.new(data).result binding
  end

  def self.render_view(name, context)
    process Resource::view(name), context
  end

  def self.render_layout(name, context)
    process Resource::layout(name), context
  end

  private_class_method :process
  private_class_method :render_view
  private_class_method :render_layout

end