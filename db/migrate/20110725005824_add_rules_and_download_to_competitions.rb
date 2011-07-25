class AddRulesAndDownloadToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :rules, :string
    add_column :competitions, :download, :string
  end
end
