class SitemapController < ApplicationController
  before_filter :set_actions, if: proc { current_user&.admin_less? }

  def index
    sitemap = Sitemap.new.all
    if current_user&.admin_less?
      @current_page_list = if defined?(TsEshop)
                             Kaminari.paginate_array(sitemap.items).page(params[:page])
                           else
                             sitemap.items
                           end
      @list_pages = Admin::ListPages.new do |l|
        l.controller_name = controller_name
        l.action_name = action_name
        l.h1 = ' - Структура сайта'
        l.list = @current_page_list
        l.list_opts = sitemap.items_opts
      end
      render 'admin_index'
    else
      sitemap.items.delete_if do |r|
        (r.respond_to?('id_str') && r.id_str == 'home_index_page') || (r.respond_to?('del') && r.del)
      end
      respond_to do |format|
        format.html { render 'index', locals: { sitemap: sitemap }}
        format.xml { render 'index', locals: { sitemap: sitemap }}
      end
    end
  end

  def show
  end


  private

  def set_actions
    @admin_panel = Admin::Panel::Base.new(:sitemap, { routes: [:edit, :destroy, :show] })
    @admin_panel.from(controller_name, action_name)
  end
end
