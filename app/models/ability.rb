# -*- encoding : utf-8 -*-
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
      can :del, :all
      # can :access, :ckeditor
      # can [:read, :create, :destroy], Ckeditor::Picture
      # can [:read, :create, :destroy], Ckeditor::AttachmentFile
    elsif user.admin_less?
      can :read, :all
      can :create, :all
      can :update, :all
      can :del, :all
      can :manage, [:admin]
      can [:edit_content, :save_content, :cancel_save_content], TemplateSystem::TemplateContent
      can [:edit_content, :save_content, :cancel_save_content], TemplateSystem::TemplateTableContent
      can [:new_block, :new_block_table, :create_block, :create_block_table], TemplateSystem::Template
      can [:new_block, :create_block], TemplateSystem::TemplateTableContent

      can :access, :ckeditor
      can [:read, :create, :destroy], Ckeditor::Picture
      can [:read, :create, :destroy], Ckeditor::AttachmentFile

      can [:read, :create], User
      can :update, User do |user|
        user.try(:if) == current_user.id
      end
    else
      can :read, :all
      # can [:error_message, :send_error_message], ::PageContent
      # can [:order, :send_order], ::PageContent
      can :new, :contact_form

      cannot :all, ::BizInfo
      cannot [:index, :pages], ::Page
      cannot :read, :user

      cannot :read, TemplateSystem::Settings::Home
      cannot :read, :theme
      # cannot :read, :theme_preview
      cannot :read, TemplateSystem::Content
      cannot :read, TemplateSystem::Template
      cannot :read, TemplateSystem::TemplatePart
      cannot :read, TemplateSystem::TemplatePartsTag
      cannot :read, TemplateSystem::TemplateTypeCategory
      cannot :read, TemplateSystem::TemplateType
      cannot :read, TemplateSystem::TemplateTag
      cannot :read, TemplateSystem::TemplateTypesTag
      cannot :read, TemplateSystem::TemplateContent
      cannot :read, TemplateSystem::TemplateTableContent
    end
  end
end
