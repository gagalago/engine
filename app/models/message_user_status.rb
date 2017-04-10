# == Schema Information
#
# Table name: message_user_statuses
#
#  id         :uuid             not null, primary key
#  message_id :uuid             not null
#  user_id    :uuid             not null
#  notified   :boolean          default(FALSE), not null
#  read       :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  idx_message_status_component_key           (message_id,user_id) UNIQUE
#  index_message_user_statuses_on_message_id  (message_id)
#  index_message_user_statuses_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_message_status_to_messages  (message_id => messages.id)
#  fk_message_status_to_users     (user_id => users.id)
#

class MessageUserStatus < ActiveRecord::Base
  track_entity_changes

  belongs_to :user
  belongs_to :message

  def self.build_from_message(message, user, is_read=false)
    status          = message.message_user_statuses.build
    status.user     = user
    status.notified = is_read
    status.read     = is_read
    status
  end

  def self.build(message_id, user_id, is_read=false)
    status            = MessageUserStatus.new
    status.message_id = message_id
    status.user_id    = user_id
    status.notified   = is_read
    status.read       = is_read
    status
  end

  def self.mark_as_read(user_id, message_id)
    status = find_by!(user_id: user_id, message_id: message_id)
    status.mark_as_read
    status.save!
  end

  def self.mark_as_notified(user_id, message_id)
    status = find_by!(user_id: user_id, message_id: message_id)
    status.mark_as_notified
    status.save!
  end

  def self.mark_all_as_read_in_room_for_user(user_id, room_id, last_read_message_public_id)
    transaction do
      statuses = joins(:message).where("(NOT notified OR NOT read)")
                                .where(user_id: user_id)
                                .where(messages: {room_id: room_id})
      if last_read_message_public_id
        statuses = statuses.where("messages.sequence_number <= (SELECT sequence_number FROM messages WHERE public_id=?)", last_read_message_public_id)
      end
      statuses.each(&:mark_as_read)
      statuses.each(&:save!)
      statuses
    end
  end

  def self.destroy_statuses_for_user_in_room(user_id, room_id)
    joins(:message).where(user_id: user_id)
                   .where(messages: {room_id: room_id})
                   .destroy_all
  end

  def self.create_read_statuses_for(new_membership)
    transaction do
      new_statuses = new_membership.room.messages.ids.map do |message_id|
        build(message_id, new_membership.user_id, true)
      end
      new_statuses.each(&:save!)
      new_statuses
    end
  end

  def mark_as_read
    self.read = true
    mark_as_notified
  end

  def mark_as_notified
    self.notified = true
  end
end
