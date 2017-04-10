require "rails_helper"

RSpec.describe "user", :user do
  let(:base_url) { "/user/rooms/:roomId/membership" }

  describe "rooms" do
    describe "membership" do
      let(:room_id) { SecureRandom.uuid }
      let(:url)     { base_url.gsub(":roomId", room_id) }

      before(:each) do
        @room = RoomFactory.build_from_server($platform, data: {id: room_id})
        @room.save!
        @membership = MembershipFactory.build_from_server($platform, {room_id: @room.public_id, user_id: $user.public_id})
        @membership.save!
        @other_membership = MembershipFactory.build_from_server($platform, {room_id: @room.public_id, user_id: $other_user.public_id})
        @other_membership.save!
      end

      describe "PUT membership" do
        context "when the membership is open" do
          before(:each) do
            @membership.open = true
            @membership.save!
          end

          it "stays open when called with the open attribute set to true" do
            data = { data: { type: :membership, attributes: {open: true} } }
            put(url, params: data.to_json, headers: $headers)
            expect(@membership.reload.open).to be(true)
          end

          it "sets it to closed when called with the open attribute set to false" do
            data = { data: { type: :membership, attributes: {open: false} } }
            put(url, params: data.to_json, headers: $headers)
            expect(@membership.reload.open).to be(false)
          end
        end

        context "when the membership is closed" do
          before(:each) do
            @membership.open = false
            @membership.save!
          end

          it "sets it to open when called with the open attribute set to true" do
            data = { data: { type: :membership, attributes: {open: true} } }
            put(url, params: data.to_json, headers: $headers)
            expect(@membership.reload.open).to be(true)
          end

          it "stays closed when called with the open attribute set to false" do
            data = { data: { type: :membership, attributes: {open: false} } }
            put(url, params: data.to_json, headers: $headers)
            expect(@membership.reload.open).to be(false)
          end
        end

        context "when called with a non-existing room id" do
          let(:inexsistant_room_id) { SecureRandom.uuid }

          it "returns a 404" do
            inexsistant_room_url = url.gsub(room_id, inexsistant_room_id)
            data                 = { data: { type: :membership, attributes: {open: true} } }
            put(inexsistant_room_url, params: data.to_json, headers: $headers)
            expect(response).to have_http_status(:not_found)
          end

          it "returns a not found error" do
            inexsistant_room_url = url.gsub(room_id, inexsistant_room_id)
            data                 = { data: { type: :membership, attributes: {open: true} } }
            put(inexsistant_room_url, params: data.to_json, headers: $headers)
            expect(json["errors"].size).to be(1)
          end
        end
      end
    end
  end
end
