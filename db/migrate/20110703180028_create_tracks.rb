class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.integer :user_id
      t.integer :tid
      t.string :title
      t.string :permalink
      t.string :artwork_url
      t.string :waveform_url

      t.timestamps
    end
  end
end
