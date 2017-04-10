class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages, id: :uuid do |t|
      t.uuid    :room_id, index: true
      t.uuid    :sender_id, index: true
      t.text    :content
      t.string  :content_type

      t.timestamps null: false
    end
  end
end
