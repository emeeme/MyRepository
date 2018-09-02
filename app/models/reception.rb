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
   
end
