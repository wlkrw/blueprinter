module SwaggerAnnotations
  def swagger_definition(method=nil)
    return @__swagger__[method] if method
    @__swagger__
  end

  def add_field_to_swagger(field_name)
    @__swagger__ ||= initial_swagger
    @__swagger__[:properties][field_name] = @__last_swagger_annotation__ if @__last_swagger_annotation__
    @__last_swagger_annotation__ = nil
  end

  private

  def method_missing(meth, *args)
    return super unless /\A_/ =~ meth
    @__last_swagger_annotation__ = args.size == 1 ? args.first : args
  end

  def initial_swagger
    {
      type: "object",
      properties: {}
    }
  end
end

class Module
  private

  def swagger_annotate!
    extend SwaggerAnnotations
  end
end
