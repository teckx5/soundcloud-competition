class AddRecordingToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :recording, :boolean, :default => false
  end
end
