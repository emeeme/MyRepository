class ReceptionsController < ApplicationController

  def index
    @receptions = Reception.all.order(productno:'asc')
  end

  def show
    @reception = Reception.find(params[:id])
  end

  def new
    @reception = Reception.new
  end

  def create
    @reception = Reception.new(reception_params)
    if @reception.save
        redirect_to receptions_path
    else
        render 'new'
    end
  end

  def edit
    @reception = Reception.find(params[:id])
  end

  def update
    @reception = Reception.find(params[:id])
    if @reception.update(reception_params)
        redirect_to receptions_path
    else
        render 'edit'
    end
  end

  def destroy
    @reception = Reception.find(params[:id])
    @reception.destroy
    redirect_to receptions_path
  end

  def import
    Reception.import(params[:file])
    redirect_to root_url, notice: "追加しました。"
  end

  def print
    Reception.print
  end

  private 
    def reception_params
        params.require(:reception)
        .permit(
          :productno ,
          :lotno, 
          :producttype, 
          :steeltype, 
          :size, 
          :quantity)
    end

end
