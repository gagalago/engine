class CreateMessageDailyMetricsReport < ActiveRecord::Migration
  def change
    create_table :message_daily_metrics_reports, id: :uuid do |t|
      t.date    :date
      t.uuid    :platform_id
      t.integer :messages_sent
      t.integer :messages

      t.timestamps null: false
    end
    add_index :message_daily_metrics_reports, [:date, :platform_id], unique: true
  end
end
