class CreateLeagues < ActiveRecord::Migration[7.0]
  def change
    create_table :leagues do |t|

      t.timestamps
    end
  end
end
