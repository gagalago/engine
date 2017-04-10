class RemoveUserDailyMetricsReport < ActiveRecord::Migration
  def change
    drop_table :user_daily_metrics_reports
  end
end
