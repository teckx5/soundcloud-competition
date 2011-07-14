class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :uid
      t.string :name
      t.string :username
      t.string :permalink
      t.string :avatar_url
      t.string :city
      t.string :country
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end
