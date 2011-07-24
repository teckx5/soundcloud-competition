class AddCompetitionIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :competition_id, :integer
  end
end
