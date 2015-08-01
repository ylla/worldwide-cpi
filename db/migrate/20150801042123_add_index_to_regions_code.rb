class AddIndexToRegionsCode < ActiveRecord::Migration
  def change
  	add_index :regions, :code, unique: true
  end
end
