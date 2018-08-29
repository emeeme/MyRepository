class ReceptionsController < ApplicationController

  def index
    @receptions = Reception.all.order(created_at:'desc')
  end

  def show
    @reception = Reception.find(params[:id])
  end

  def new
    @reception = Reception.new
  end

  def create
    @reception = Reseption.new(reception_params)
    if @post.save
        redirect_to reception_path
    else
        render 'new'
    end
  end

  def edit
    @reception = Reception.find(params[:id])
  end

  def update
    @post = Reception.find(params[:id])
    if @reception.update(reception_params)
        redirect_to receptions_path
    else
        render 'edit'
    end
  end

  def destroy
    @post = Reception.find(params[:id])
    @post.destroy
    redirect_to receptions_path
  end

  private 
    def reception_params
        params.require(:reception).permit(:productno ,:lotno, :producttype, :steeltype, :size, :quantity)
    end

end
