class RemoveRoomsDailyMetricsReport < ActiveRecord::Migration
  def change
    drop_table :room_daily_metrics_reports
  end
end
