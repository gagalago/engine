class AddSequenceNumberToMessages < ActiveRecord::Migration
  def up
    add_column :messages, :sequence_number, :serial, null: false
    count = 0
    Message.order(created_at: :asc).each do |message|
      message.sequence_number = count
      count += 1
      message.save!
    end
    add_index :messages, :sequence_number, unique: true
  end

  def down
    remove_column :messages, :sequence_number
  end
end
