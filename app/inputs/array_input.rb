class ArrayInput < SimpleForm::Inputs::StringInput
  def input(_wrapper_options = nil)
    input_html_options[:type] ||= input_type

    out = Array(object.public_send(attribute_name)).map do |array_el|
      @builder.text_field(nil, input_html_options.merge(value: array_el, name: "#{object_name}[#{attribute_name}][]"))
    end.join

    data_values = "data-name='#{object_name}[#{attribute_name}][]' data-class='#{input_html_classes}' data-type='#{input_type.join(' ')}'"
    out += "<a class='btn btn-link btn-sm add-array-field' #{data_values}>+ Add</a><br/>"

    out.html_safe
  end

  def input_type
    %i[text array]
  end

  def input_class
    'form-group'
  end

  def input_html_classes
    'form-array-control deletable '
  end
end
