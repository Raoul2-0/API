class TableService

    def initialize(global_params)
      @global_params = global_params
      @current_user = global_params[:current_user]
      @user_permissions = global_params[:user_permissions]
      @elements = global_params[:elements]
      @table_ref = global_params[:table_ref]
      @current_school = global_params[:current_school]
      @argument = global_params[:argument]
      @data_type = global_params[:data_type]
      @minimal = global_params[:minimal]
      @params = global_params[:params]

      try('local_init', global_params)
    end

    def admin?
      @current_user.is_admin
    end

    def create_header
      raise NotImplementedError
    end

    def make_block(element)
      return element if @data_type == 'original'

      raise NotImplementedError
    end

    def create_table_body
      body_infos
    end

    def info_standard(info, text, options = {})
      my_cel = cel([{ class: "#{info} cel" }])
      my_micro_cel = micro_cel([{ class: "#{info} micro_cel"}], text, options)
      my_cel[:list] = [my_micro_cel].compact
      my_cel
    end

    def cel(attributes = {})
      {
        attributes: attributes,
        list: []
      }
    end

    def micro_cel(attributes, text = nil, options = {})
      return nil if attributes.blank? && value.blank?

      {
        attributes: attributes,
        type: (options[:value] && options[:value][:icon]).present? ? 'icon_text' : 'text',
        value: { 
          text: text 
        }
      }.merge(options)
    end

    def body_infos
      return @elements if @data_type == 'original'

      formated_elements = []
      @elements.each do |element|
        formated_elements.push(make_block(element))
      end

      formated_elements.compact
    end

    def foreground(element)
      boolean_values(element.foreground, 'foreground')
    end

    def sidebar(element)
      boolean_values(element.sidebar, 'sidebar')
    end

    def boolean_values(value = false, classes = '')
      options = {
        value: {
          text: ''
        }
      }
  
      if value.present?
        options[:value][:icon] = {
          name: "fas fa-check",
          class: "text-primary",
          size: "0.8rem",
      }
      end

      info_standard(classes, nil, options)
    end
end