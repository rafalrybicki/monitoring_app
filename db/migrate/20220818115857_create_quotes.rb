class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes do |t|
      t.string :content, null: false
      t.string :author, null: true
      t.integer :order, default: 0

      t.timestamps
    end
  end
end
