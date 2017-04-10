class CreateRoomDailyMetricsReport < ActiveRecord::Migration
  def change
    create_table :room_daily_metrics_reports, id: :uuid do |t|
      t.date    :date
      t.uuid    :platform_id
      t.integer :rooms_created
      t.integer :rooms

      t.timestamps null: false
    end
    add_index :room_daily_metrics_reports, [:date, :platform_id], unique: true
  end
end
