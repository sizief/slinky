class CreateStats < ActiveRecord::Migration[5.2]
  def change
    create_table :stats do |t|
      t.references :url
      t.timestamps null: false
    end
  end
end
