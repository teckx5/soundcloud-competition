class AddTracksCountToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :tracks_count, :integer, :default => 0
  end
end
