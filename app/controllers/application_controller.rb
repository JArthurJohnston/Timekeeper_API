class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def index
    @models = find_all params
    render json: @models
  end

  def create
    @new_model = model_class.create(model_params)
    render json: @new_model
  end

  def show
    @model = find_model params
    render json: @model
  end

  def update
    @model = find_model(params)
    @model.update_attributes(model_params)
    render json: @model
  end

  def destroy
    @model = find_model(params).destroy
    render :nothing => true, :status => 200
  end

  private

    def model_class
      raise 'subclass responsibility'
    end

    def model_params
      raise 'subclass responsibility'
    end

    def find_all params
      return model_class.all
    end

    def find_model params
      return model_class.find(params[:id])
    end

end
