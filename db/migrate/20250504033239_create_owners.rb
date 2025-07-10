class CreateOwners < ActiveRecord::Migration[7.1]
  def change
    create_table :owners do |t|
      t.references :user, null: false, foreign_key: true
      t.references :dewback, null: false, foreign_key: true

      t.timestamps
    end

    add_index :owners, [:user_id, :dewback_id], unique: true
  end
end
