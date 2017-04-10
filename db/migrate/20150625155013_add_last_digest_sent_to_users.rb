class AddLastDigestSentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_messages_digest_sent_at, :datetime
  end
end
