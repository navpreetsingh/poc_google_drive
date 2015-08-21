class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :image_link
      t.string :access_token
      t.datetime :expires_at
      t.string :refresh_token


      t.timestamps null: false
    end
  end
end
