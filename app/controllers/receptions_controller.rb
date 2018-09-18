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

    #report.page.item(:qrimage).src(makeqr)


    # ブラウザでPDFを表示させたい場合
    # パラメタのdisposition: "inline" をつけない場合は、PDFがダウンロードされる
    # ,disposition: "inline"
    send_data(
    report.generate,
    filename:    "#{@reception.productno}.pdf",
    type:        "application/pdf"
    )
  end

  def makeqr2()
    require 'rqrcode'
    require 'rqrcode_png'
    require 'chunky_png' # to_data_urlはchunky_pngのメソッド

    content = 'aaa'
    size    = 3
    # 1..40
    level   = :m         
    # l, m, q, h

    qr = RQRCode::QRCode.new(content, size: size, level: level)
    # png変換->リサイズ->base64エンコード
    return qr.to_img.resize(200, 200).to_data_url

  end

  def makeqr()
    # -*- encoding: sjis -*-
    require 'rqrcode'
    require 'chunky_png' 
    require 'base64'
    require 'stringio'

    # 「Hello Wolrd!!」いう文字列、サイズは3、誤り訂正レベルHのQRコードを生成する
    qr = RQRCode::QRCode.new( "Hello World!!", :size => 3, :level => :h )


    png = qr.to_img

    return png
    
    #200×200にリサイズして「hello_world.png」というファイル名で保存する
    png.resize(200, 200).save("hello_world.png")

   
    #return qr.as_png.resize(500,500)
    
    red_dot = png.to_data_url

    #red_dot = 'iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4' +
    #          '//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg=='
    base64_image = StringIO.new(Base64.decode64(red_dot))
    return base64_image
   
    #return 
    #return StringIO.new(Base64.decode64(ChunkyPNG::Image.from_datastream(
    #  qr.as_png.resize(500,500).to_datastream).to_data_url))

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
