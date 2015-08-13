class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    @models = model_class.all
  end

  def new
    @new_model = model_class.new
    # respond_with(@new_model) doesnt make sense here. show doesnt touch the model, just serves up a form
  end

  def create
    @new_model = model_class.create(model_params)
  end

  def edit
    @model = find_model(params)
    respond_with(@model)
  end

  def update
    @model = find_model(params)
    @model.update_attributes(model_params)
  end

  def destroy
    @model = find_model(params).destroy
  end

  def show
    @model = find_model params
    respond_with(@model)
  end

  private

    def model_class
      raise 'subclass responsibility'
    end

    def model_params
      raise 'subclass responsibility'
    end

    def find_all
      return model_class.all
    end

    def find_model params
      return model_class.find(params[:id])
    end

end
