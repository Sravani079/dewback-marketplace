class AddTitleToDewbacks < ActiveRecord::Migration[7.1]
  def change
    add_column :dewbacks, :title, :string
  end
end
