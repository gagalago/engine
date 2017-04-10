class RemoveLastMessagesDigestSentAtFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :last_messages_digest_sent_at
  end
end
