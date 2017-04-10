class AddReadByUserIdsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :read_by_user_ids, :text, array: true, default: [], index: true
  end
end
