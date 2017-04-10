require "rails_helper"

RSpec.describe "GET /user", :user do
  let(:base_url) { "/user" }

  it "returns a 200" do
    get(base_url, headers: $headers)
    expect(response).to have_http_status(:ok)
  end

  it "returns the id of the current user" do
    get(base_url, headers: $headers)
    expect(json["data"]["id"]).to eq($user.public_id)
  end

  context "when the current user has no unread messages" do
    it "returns an unread message count of 0" do
      get(base_url, headers: $headers)
      expect(json["data"]["meta"]["unreadMessageCount"]).to eq(0)
    end
  end

  context "when the current user has 10 unread messages" do
    let(:room_id) { SecureRandom.uuid }

    before(:each) do
      room       = RoomFactory.build_from_server($platform, data: { id: room_id })
      room.save!
      membership = MembershipFactory.build_from_server($platform, {room_id: room_id, user_id: $user.public_id})
      membership.save!
      user       = UserFactory.build_from_server($platform, {})
      user.save!

      user_membership = MembershipFactory.build_from_server($platform, {room_id: room_id, user_id: user.public_id})
      user_membership.save!

      1.upto(10) do
        message = MessageFactory.build_from_server($platform, {
          room_id: room_id,
          data:    {
            relationships: {
              user: {
                data: {
                  id: user.public_id
                }
              }
            },
            attributes:   {
              content: "Pouet"
            }
          }
        })
        message.save!
      end
    end

    it "returns an unread message count of 10" do
      get(base_url, headers: $headers)
      expect(json["data"]["meta"]["unreadMessageCount"]).to eq(10)
    end
  end

  context "when the current user has no rooms" do
    it "returns an room count of 0" do
      get(base_url, headers: $headers)
      expect(json["data"]["meta"]["roomCount"]).to eq(0)
    end
  end

  context "when the current user has 5 rooms" do
    before(:each) do
      1.upto(5) do
        room       = RoomFactory.build_from_server($platform, {})
        room.save!
        membership = MembershipFactory.build_from_server($platform, {room_id: room.public_id, user_id: $user.public_id})
        membership.save!
      end
    end

    it "returns an unread message count of 5" do
      get(base_url, headers: $headers)
      expect(json["data"]["meta"]["roomCount"]).to eq(5)
    end
  end
end
