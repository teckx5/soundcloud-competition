class ChangeGroupInCompetitions < ActiveRecord::Migration
  def up
    change_column :competitions, :group, :integer
  end

  def down
    change_column :competitions, :group, :string
  end
end
