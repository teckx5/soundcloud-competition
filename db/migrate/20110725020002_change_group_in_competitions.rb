class ChangeGroupInCompetitions < ActiveRecord::Migration
  def up
    remove_column :competitions, :group
    add_column :competitions, :group, :integer
  end

  def down
    remove_column :competitions, :group
    add_column :competitions, :group, :string
  end
end
