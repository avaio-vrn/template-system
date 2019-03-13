# -*- encoding : utf-8 -*-
module ExceptionsErrors
  class AuthenticationError < StandardError
    def initialize(message='Нет доступа'.freeze)
      @status = 401
      @message = 'Нет доступа'.freeze if message.blank?
    end

    def to_s
      @message
    end

    def status
      @status
    end
  end

  class LackAuthorityError < StandardError
    def initialize
      @status = 403
      @message = 'Нет полномочий'.freeze
    end
  end

  class InvalidUser < AuthenticationError
    def initialize
      @message = 'Такой пользователь не зарегистрирован'.freeze
    end
  end

  class InvalidLogin < AuthenticationError
    def initialize
      super
      @message = 'Неверный логин и/или пароль'.freeze
    end
  end

  class InvalidAcceptAccess < AuthenticationError
    def initialize
      super
      @message = 'Заявка на рассмотрении'.freeze
    end
  end

  class InvalidAccountAccess < AuthenticationError
    def initialize
      super
      @message = 'Неверные данные доступа в аккаунт'.freeze
    end
  end

  class NeedActivateAccount < AuthenticationError
    def initialize
      super
      @message = 'Необходимо активировать аккаунт.
                  Письмо было выслано на почту.'.freeze
    end
  end
end
