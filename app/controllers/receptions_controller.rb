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

    #report.page.item(:qrimage).value(makeqr)

    # ブラウザでPDFを表示させたい場合
    # パラメタのdisposition: "inline" をつけない場合は、PDFがダウンロードされる
    # ,disposition: "inline"
    send_data(
    report.generate,
    filename:    "#{@reception.productno}.pdf",
    type:        "application/pdf"
    )
  end

  def makeqr()
    # -*- encoding: sjis -*-
    require 'rqrcode'
    require 'rqrcode_png'
    require 'chunky_png'

    # 「Hello Wolrd!!」いう文字列、サイズは3、誤り訂正レベルHのQRコードを生成する
    qr = RQRCode::QRCode.new( "Hello World!!", :size => 3, :level => :h )
    png = qr.to_img

    #200×200にリサイズして「hello_world.png」というファイル名で保存する
    png.resize(200, 200).save("hello_world.png")
    return png
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
