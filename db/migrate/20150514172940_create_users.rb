class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :uuid do |t|
      t.uuid :application_id, index: true

      t.timestamps null: false
    end
  end
end
