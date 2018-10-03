class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :shortcode
      t.string :url
      t.timestamps null: false
    end
  end
end
