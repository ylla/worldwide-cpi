class CreatePriceIndices < ActiveRecord::Migration
  def change
    create_table :price_indices do |t|
      t.date :year
      t.float :value
      t.references :region, index: true

      t.timestamps null: false
    end
    add_foreign_key :price_indices, :regions
    add_index :price_indices, [:region_id, :year], unique: true
  end
end
