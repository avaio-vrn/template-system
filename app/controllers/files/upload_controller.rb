class Files::UploadController < ApplicationController
  authorize_resource class: false

  def create
    file = Files::Upload.new(params[:upload])
    if file.save
      render json:  { filename: file.filename }, layout: false
    else
      render json:  { error: 'save error' }, layout: false
    end
  end
end
