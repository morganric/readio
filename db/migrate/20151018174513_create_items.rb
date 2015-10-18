class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.date :pub_date
      t.string :url
      t.string :link
      t.string :guid
      t.string :author
      t.text :description
      t.integer :duration
      t.string :image
      t.string :slug
      t.integer :feed_id

      t.timestamps null: false
    end
  end
end
