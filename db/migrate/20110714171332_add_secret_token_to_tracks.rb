class AddSecretTokenToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :secret_token, :string
  end
end
