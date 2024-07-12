class RemoveDefunctColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :leagues, :base_url
    remove_column :leagues, :schedule_path
    remove_column :leagues, :standings_path
    remove_column :leagues, :parsing_strategy
  end
end
