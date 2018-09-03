class Reception < ApplicationRecord
    validates :productno, presence: true

    def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
            reception = find_by(productno: row["productno"]) || new
            reception.attributes = row.to_hash.slice(*updatable_attributes)
            reception.save!
        end
    end

    def self.updatable_attributes
        ["productno","lotno","producttype","steeltype","size","quantity"]
    end

    def printPdf(reception_id)
        report = ThinReports::Report.new(layout: "#{Rails.root}/public/pdfs/sampleprint.tlf")
        reception = Reception.find_by(id: reception_id)

        report.start_new_page
        report.page.item(:productno).value(reception.productno)
        report.page.item(:lotno).value(reception.lotno)
        report.page.item(:producttype).value(reception.producttype)
        report.page.item(:steeltype).value(reception.steeltype)
        report.page.item(:size).value(reception.size)
        report.page.item(:quantity).value(reception.quantity)

        send_data(
            report.generate,
            filename: "sample.pdf",
            type: "application/pdf",
            disposition: "inline"
        )
    end
   
end
