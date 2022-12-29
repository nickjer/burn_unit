# frozen_string_literal: true

class SelectBlockInput < SimpleForm::Inputs::CollectionInput
  def input(wrapper_options = nil)
    merged_input_options =
      merge_wrapper_options(input_html_options, wrapper_options)

    options = input_options.delete(:options)
    @builder.select(
      attribute_name, nil, input_options, merged_input_options
    ) do
      options
    end
  end
end
