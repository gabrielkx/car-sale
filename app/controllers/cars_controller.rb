class CarsController < ApplicationController

  # app/controllers/cars_controller.rb
  def index
    @cars = Car.paginate(page: params[:page], per_page: 8) # 9 carros por página, ajuste conforme necessário
  end

  def new
    @car = Car.new
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
    redirect_to cars_path, notice: 'Carro foi excluído com sucesso.'
  end

  def show
    @car = Car.find(params[:id])
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      redirect_to cars_path
    else
      render 'new'
    end
  end

  def filter
    @filtered_cars = Car.all
  
    if params[:make].present?
      @filtered_cars = @filtered_cars.where(make: params[:make])
    end
  
    if params[:year].present?
      @filtered_cars = @filtered_cars.where(year: params[:year])
    end
  
    if params[:model].present?
      @filtered_cars = @filtered_cars.where('lower(model) LIKE ?', "%#{params[:model].downcase}%")
    end
  
    @cars = @filtered_cars.paginate(page: params[:page], per_page: 8)
  
    render 'index' # Redirecione para a view de índice com os resultados filtrados
  end
  
  private  
  
  def car_params
    params.require(:car).permit(:make, :title, :description, :model, :year, :price, images: [])
  end
end
