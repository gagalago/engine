require "rails_helper"

RSpec.describe "user", :user do
  let(:base_url) { "/user/rooms/:roomId/membership/unread-messages" }

  describe "rooms" do
    describe "membership" do
      describe "unread-messages" do
        let(:room_id) { SecureRandom.uuid }
        let(:other_room_id) { SecureRandom.uuid }
        let(:url)     { base_url.gsub(":roomId", room_id) }

        before(:each) do
          @room = RoomFactory.build_from_server($platform, data: {id: room_id})
          @room.save!
          @other_room = RoomFactory.build_from_server($platform, data: {id: other_room_id})
          @other_room.save!
          @membership = MembershipFactory.build_from_server($platform, {room_id: @room.public_id, user_id: $user.public_id})
          @membership.save!
          @other_membership = MembershipFactory.build_from_server($platform, {room_id: @room.public_id, user_id: $other_user.public_id})
          @other_membership.save!
        end

        def create_ten_messages(room)
          1.upto(10).map do | index |
            message = MessageFactory.build_from_server($platform, {
              room_id: room.public_id,
              data: {
                attributes: {
                  content: "My message"
                }
              }
            })
            message.save!
            message
          end
        end

        describe "PUT unread-messages" do
          context "when there are unread messages for the current user" do
            let(:unread_message_body) {
              {
                data: {
                  last_read_message_id: @last_read_message_id
                }
              }.to_json
            }

            before(:each) do
              @messages               = create_ten_messages(@room)
              @messages_in_other_room = create_ten_messages(@other_room)
            end

            it "returns a 200" do
              put(url, headers: $headers)
              expect(response).to have_http_status(:ok)
            end

            it "sets all those messages to read for the current user" do
              put(url, headers: $headers)
              unread_for_user = $user.message_user_statuses.where(read: false)
              expect(unread_for_user.size).to be(0)
            end

            it " does not sets all those messages to read implicitly for the other users" do
              put(url, headers: $headers)
              unread_for_other_user = $other_user.message_user_statuses.where(read: false)
              expect(unread_for_other_user.size).to be(@messages.size)
            end

            context "and specifying the last message id with the very last existing message" do
              before(:each) do
                @last_read_message_id = @messages.last.public_id
              end

              it "sets all those messages to read for the current user" do
                put(url, headers: $headers, params: unread_message_body)
                unread_for_user = $user.message_user_statuses.where(read: false)
                expect(unread_for_user.size).to be(0)
              end

              it "sets none of those messages to read for the other user" do
                put(url, headers: $headers, params: unread_message_body)
                unread_for_other_user = $other_user.message_user_statuses.where(read: false)
                expect(unread_for_other_user.size).to be(@messages.size)
              end
            end

            def expect_that_nth_message_has_status(user, is_read)
              @messages.each_with_index do |message, index|
                should_be_read = index <= @last_message_read_index && is_read
                actual_message = message.reload
                expect(actual_message.has_been_read_by?(user)).to be(should_be_read)
              end
            end

            context "and specifying the last message id to 4" do
              before(:each) do
                @number_of_messages_to_read = 4
                @last_message_read_index    = @number_of_messages_to_read - 1
                @last_read_message_id       = @messages[@last_message_read_index].public_id
              end

              it "sets 4 of those messages to read for the current user" do
                put(url, headers: $headers, params: unread_message_body)
                unread_for_user = $user.message_user_statuses.where(read: false)
                expect(unread_for_user.size).to be(@messages.size - @number_of_messages_to_read)
                expect_that_nth_message_has_status($user, true)
              end

              it "sets none of those messages to read for the other user" do
                put(url, headers: $headers, params: unread_message_body)
                unread_for_other_user = $other_user.message_user_statuses.where(read: false)
                expect(unread_for_other_user.size).to be(@messages.size)
                expect_that_nth_message_has_status($other_user, false)
              end
            end

            context "when called with a non-existing message public id" do
              before(:each) do
                @last_read_message_id = "wrong message id"
                @number_of_users      = 2
              end

              it "sets none of those messages to read to any status" do
                put(url, headers: $headers, params: unread_message_body)
                unread = MessageUserStatus.where(read: false)
                expect(unread.size).to be(@messages.size * @number_of_users)
              end
            end
          end

          context "when there are no unread messages for the current user" do
            it "returns a 200" do
              put(url, headers: $headers)
              expect(response).to have_http_status(:ok)
            end

            it "returns 0 as read messages count" do
              put(url, headers: $headers)
              expect(json["meta"]["count"]).to eq(0)
            end
          end

          context "when called with a non-existing room id" do
            let(:inexsistant_room_id) { SecureRandom.uuid }

            it "returns a 404" do
              inexsistant_room_url = url.gsub(room_id, inexsistant_room_id)
              data = { data: { attributes: {open: true} } }
              put(inexsistant_room_url, params: data.to_json, headers: $headers)
              expect(response).to have_http_status(:not_found)
            end

            it "returns a not found error" do
              inexsistant_room_url = url.gsub(room_id, inexsistant_room_id)
              data = { data: { attributes: {open: true} } }
              put(inexsistant_room_url, params: data.to_json, headers: $headers)
              expect(json["errors"].size).to be(1)
            end
          end
        end
      end
    end
  end
end
