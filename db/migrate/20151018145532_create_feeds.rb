class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :url
      t.string :title
      t.string :link
      t.date :pub_date
      t.text :description
      t.string :author
      t.string :language
      t.string :keywords
      t.string :owner_name
      t.string :owner_email
      t.string :category
      t.integer :user_id
      t.string :slug

      t.timestamps null: false
    end
  end
end
