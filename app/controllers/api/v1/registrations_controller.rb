module Api
  module V1
    class RegistrationsController < ApplicationController
      def create
        result = UserRegistrationService.new(registration_params[:pseudo]).call
        
        if result[:success]
          render json: {
            pseudo: result[:pseudo],
            message: result[:message]
          }, status: :created
        else
          render json: {
            error: result[:error]
          }, status: :unprocessable_entity
        end
      end

      private

      def registration_params
        params.require(:user).permit(:pseudo)
      end
    end
  end
end