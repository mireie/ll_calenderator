class CreateLeagues < ActiveRecord::Migration[7.0]
  def change
    create_table :leagues do |t|
      t.string :title
      t.string :sport
      t.string :description
      t.string :days, array: true, default: []
      t.datetime :start_date

      t.timestamps
    end
  end
end
