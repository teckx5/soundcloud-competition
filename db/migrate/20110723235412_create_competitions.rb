class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.integer :user_id
      t.string :host
      t.string :title
      t.text :intro
      t.text :description
      t.text :prizes
      t.text :about
      t.string :group
      t.string :key
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
