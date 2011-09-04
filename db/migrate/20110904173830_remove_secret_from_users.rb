class RemoveSecretFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :secret
  end

  def down
    add_column :users, :secret, :string
  end
end
