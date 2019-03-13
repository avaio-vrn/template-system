# -*- encoding : utf-8 -*-
TemplateSystem::Engine.routes.draw do
  get :error_message, to:  "base_mailer#error_message", as: :error_message
  post :send_error_message, to:  "base_mailer#send_error_message", as: :send_error_message
  get :question_form, to:  'base_mailer#question_form', as: :question_form
  post :send_question_form, to:  'base_mailer#send_question_form', as: :send_question_form

  resources :sitemap, only: [:index, :show]

  namespace :template_system do
    get 'content/:id', to: 'content#show', as: :content
    get 'content/:id/new(/:new_block)', to: 'content#new', as: :new_template

    resources :templates, only: [:new, :create, :destroy]

    resources :template_contents, only: [:edit, :update, :show]
    resources :template_table_contents, only: [:edit, :update, :show]

    get 'template_table_contents/new/:tc_id', to: 'template_table_contents#new', as: :new_row_table_template
    get 'template_table_contents/new_block/:tc_id', to: 'template_table_contents#new_block', as: :new_table_block_template
    get 'template_table_contents/new_column/:tc_id', to: 'template_table_contents#new_column', as: :new_column_table_template
    post 'template_table_contents/create_block/:tc_id', to: 'template_table_contents#create_block', as: :create_table_block_template
    delete 'template_table_contents/:id', to: 'template_table_contents#destroy', as: :template_table_content

    resources :template_type_categories, only: [:show]
    resources :template_types

    get :settings, to: 'settings/home#show', as: :settings
  end

  mount Ckeditor::Engine => '/ckeditor'
  resources :ckeditor

  get :biz_info, to: 'biz_info#show'
  get 'biz_info/:id/edit', to: 'biz_info#edit', as: :edit_biz_info
  put :biz_info, to: 'biz_info#update', as: :biz_info_index
  post :biz_info, to: 'biz_info#upload_logo', as: :upload_logo_biz_info

  namespace :files do
    post :upload, to: 'upload#create', as: :file_upload
  end

  get 'lazy_content/:id', to: 'lazy_content/base#show'

  namespace :admin do
    namespace :template_system do
      resources :persistent_data, only: :index
    end

    resources :configurations, except: :show

    get 'panel/:state', to: 'admin#panel_state', as: :panel_state
    post 'change_row_num/:md/:md_id/:direction', to: 'admin#change_row_num', as: :change_row_num
    get 'alphabetical_row_num/:md/(:md_id)', to: 'admin#alphabetical_row_num', as: :alphabetical_row_num
    post 'del/:md/:md_id/(:model_engine)/(:cancel)', to: 'admin#del', as: :del
    get 'set_del/:md/(:md_id)/(:assoc)/(:n_assoc)', to: 'admin#set_del', as: :set_del_templates

    get 'fix_row_num/:model', to: 'fix_row_num#edit', as: :edit_fix_row_num
    post :fix_row_num, to: 'fix_row_num#update', as: :fix_row_num
  end

  namespace :help_client do
    get :show, to: 'help#show'
    get "new/:script_name", to: 'help#new'
  end
end
