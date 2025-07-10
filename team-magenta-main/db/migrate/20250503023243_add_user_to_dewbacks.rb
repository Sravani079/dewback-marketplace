class AddUserToDewbacks < ActiveRecord::Migration[7.1]
  def change
    #add_reference :dewbacks, :user, null: true, foreign_key: true, index: true
  end
end
