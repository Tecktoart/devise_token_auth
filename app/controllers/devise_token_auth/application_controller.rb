module DeviseTokenAuth
  class ApplicationController < DeviseController
    include DeviseTokenAuth::Concerns::SetUserByToken

    protected

    def resource_class(m=nil)
      if m
        mapping = Devise.mappings[m]
      else
        mapping = Devise.mappings[resource_name] || Devise.mappings.values.first
      end

      mapping.to
    end

    def require_no_authentication
      assert_is_devise_resource!
      return unless is_navigational_format?
      no_input = devise_mapping.no_input_strategies

      authenticated = if no_input.present?
                        args = no_input.dup.push scope: resource_name
                        warden.authenticate?(*args)
                      else
                        warden.authenticated?(resource_name)
                      end

      if authenticated && resource = warden.user(resource_name)
        render json: I18n.t("devise.failure.already_authenticated")
      end
    end
  end
end
