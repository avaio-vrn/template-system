1. Admin::FixRowNum -> Admin::RowNum::Fix

###where FixRowNum###
change_row_num! -> md =  Admin::RowNum::Change.new(params); not_error = md.change_row_num!

2. Admin::AdminController.check_row_num! REMOVE!
change call && implementation like

```ruby
  before_filter :check_row_num, only: :index, if: proc { current_user && current_user.admin_less? }

  def check_row_num
    row_num_record = Admin::RowNum::Fix.new(:section, nil)
    if !params[:cancel_check_row_num] && row_num_record.need_check?
      redirect_to template_system.admin_edit_fix_row_num_url(:section, model_module: nil)
      end
  end
```

3. rm welcome_ts.html.erb

4. add first line in uniq templates with erb
<%# just ERB %>
