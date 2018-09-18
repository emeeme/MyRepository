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

  def print
 

    @reception = Reception.find(params[:id])
    #require 'thinreports'
    report = Thinreports::Report.new layout: 'app/pdfs/sampleprint.tlf'

    # 1st page
    report.start_new_page
    report.page.item(:productno).value(@reception.productno)
    report.page.item(:lotno).value(@reception.lotno)
    report.page.item(:producttype).value(@reception.producttype)
    report.page.item(:steeltype).value(@reception.steeltype)
    report.page.item(:size).value(@reception.size)
    report.page.item(:quantity).value(@reception.quantity)

    rowstring = ""
    rowstring += @reception.productno
    rowstring += ","
    rowstring += @reception.lotno
    rowstring += ","
    rowstring += @reception.producttype
    rowstring += ","
    rowstring += @reception.steeltype
    rowstring += ","
    rowstring += @reception.size
    rowstring += ","
    rowstring += @reception.quantity.to_s
    report.page.item(:qrimage).src(barcode(
    :qr_code, rowstring, ydim: 5, xdim: 5))


    # ブラウザでPDFを表示させたい場合
    # パラメタのdisposition: "inline" をつけない場合は、PDFがダウンロードされる
    # ,disposition: "inline"
    send_data(
    report.generate,
    filename:    "#{@reception.productno}.pdf",
    type:        "application/pdf"
    )
  end

  require 'bundler'
  Bundler.require
  
  require 'barby/barcode/ean_13'
  require 'barby/barcode/ean_8'
  require 'barby/barcode/qr_code'
  require 'barby/outputter/png_outputter'

  def barcode(type, data, png_opts = {})
    code = case type
    when :ean_13
      Barby::EAN13.new(data)
    when :ean_8
      Barby::EAN8.new(data)
    when :qr_code
      Barby::QrCode.new(data)
    end
    StringIO.new(code.to_png(png_opts))
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

  def csv_output
    @receptions = Reception.all
    send_data render_to_string, filename: "reception.csv", type: :csv
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
