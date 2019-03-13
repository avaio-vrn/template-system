class Admin::ListPages
  attr_writer :h1, :namespace, :controller_name, :action_name, :list, :list_opts, :btn_actions, :columns

  def initialize
    yield self
  end

  def h1
    "#{h1_from_translation} #{@h1}"
  end

  def items
    @list || instance_variable_get("@#{@controller_name.pluralize}") || []
  end

  def items_opts
    @list_opts
  end

  def btn_actions
    @btn_actions
  end

  def columns
    @columns
  end

  def partial
    columns.nil? ? 'admin/row_admin_index' : 'admin/row_admin_index_with_columns'
  end

  def partial_editing_buttons
    "admin/editing_buttons"
  end

  private

  def h1_from_translation
    with_namespace = @namespace.blank? ? @controller_name : [@namespace, @controller_name].join('/')
    I18n.t("#{with_namespace}.#{@action_name}.header_h1")
  end
end
