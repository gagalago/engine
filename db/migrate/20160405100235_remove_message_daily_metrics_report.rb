class RemoveMessageDailyMetricsReport < ActiveRecord::Migration
  def change
    drop_table :message_daily_metrics_reports
  end
end
