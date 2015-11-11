module DeviseTokenAuth
  class UnlocksController < DeviseTokenAuth::ApplicationController
    prepend_before_filter :require_no_authentication

    # GET /resource/unlock/new
    def new
      self.resource = resource_class.new
    end

    # POST /resource/unlock
    def create
      self.resource = resource_class.send_unlock_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        render json: { notice: 'Successfully Sent' }
      else
        render json: { error: 'Error Sent' }
      end
    end

    # GET /resource/unlock?unlock_token=abcdef
    def show
      self.resource = resource_class.unlock_access_by_token(params[:unlock_token])
      yield resource if block_given?

      if resource.errors.empty?
        render json: { notice: 'Successfully unlocked' }
      else
        render json: resource.errors
      end
    end

    protected

    def translation_scope
      'devise.unlocks'
    end
  end
end
