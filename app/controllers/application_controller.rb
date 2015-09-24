require_relative '../../app/controllers/paramaterize'

class ApplicationController < ActionController::Base
  include Paramaterize
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def index
    @models = find_all
    render json: @models
  end

  def create
    @new_model = model_class.create(using_parameters(create_parameters))
    render json: @new_model
  end

  def show
    @model = find_model
    render json: @model
  end

  def update
    @model = find_model
    @model.update(model_parameters)
    render json: @model
  end

  def destroy
    @model = find_model.destroy
    render :nothing => true, :status => 200
  end

  private

    def model_class
      raise 'subclass responsibility'
    end

    def create_parameters
      raise 'subclass responsibility'
    end

    def find_all
      return model_class.all
    end

    def find_by_user
      return model_class.where(user_id: params[:user_id])
    end

    def find_model
      return model_class.find(params[:id])
    end

    def cache_params
      @parameters = params
    end

    def params
      unless @parameters.nil?
        return @parameters
      end
      super
    end

end
