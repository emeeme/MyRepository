class CreateReceptions < ActiveRecord::Migration[5.2]
  def change
    create_table :receptions do |t|
      t.string :productno
      t.string :lotno
      t.string :producttype
      t.string :steeltype
      t.string :size
      t.integer :quantity

      t.timestamps
    end
  end
end
