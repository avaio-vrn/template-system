class LazyContent::BaseController < ApplicationController
  def show
    respond_to do |format|
      format.html { render inline: '', status: 204, layout: nil }
      format.js { render 'show', layout: nil,  locals: { lazy_content: LazyContent::Base.new(params['id'].strip) }}
    end
  end
end
