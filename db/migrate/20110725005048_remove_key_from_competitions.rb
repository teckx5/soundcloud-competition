class RemoveKeyFromCompetitions < ActiveRecord::Migration
  def up
    remove_column :competitions, :key
  end

  def down
    add_column :competitions, :key, :string
  end
end
