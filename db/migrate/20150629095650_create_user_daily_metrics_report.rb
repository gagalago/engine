class CreateUserDailyMetricsReport < ActiveRecord::Migration
  def change
    create_table :user_daily_metrics_reports, id: :uuid do |t|
      t.date    :date
      t.uuid    :platform_id
      t.integer :users_created
      t.integer :users

      t.timestamps null: false
    end
    add_index :user_daily_metrics_reports, [:date, :platform_id], unique: true
  end
end
