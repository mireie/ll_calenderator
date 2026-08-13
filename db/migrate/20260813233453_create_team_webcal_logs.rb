class CreateTeamWebcalLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :team_webcal_logs do |t|
      t.references :team, null: false, foreign_key: true
      t.string :ip_address
      t.text :user_agent

      t.timestamps
    end
  end
end
