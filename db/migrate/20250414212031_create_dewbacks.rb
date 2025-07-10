class CreateDewbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :dewbacks do |t|
      t.string :color
      t.string :size
      t.string :max_speed
      t.string :max_load
      t.string :food_requirements
      t.decimal :price
      t.integer :quantity
      t.text :description
      t.string :image

      t.timestamps
    end
  end
end
