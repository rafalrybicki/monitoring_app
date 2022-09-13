class AddSlugToDays < ActiveRecord::Migration[7.0]
  def change
    add_column :days, :slug, :string
    add_index :days, :slug, unique: true
  end
end
