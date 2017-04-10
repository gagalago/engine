require "rails_helper"

RSpec.describe "user", :user do
  let(:base_url) { "/user/rooms/:roomId/memberships" }
  describe "rooms" do
    describe "memberships" do
      let(:room_id) { SecureRandom.uuid }
      let(:url)     { base_url.gsub(":roomId", room_id) }

      before(:each) do
        @room = RoomFactory.build_from_server($platform, data: {id: room_id })
        @room.save!
        MembershipFactory.build_from_server($platform, { room_id: @room.public_id, user_id: $user.public_id }).save!
      end

      describe "POST memberships" do
        context "when called with an existing user id" do
          let(:user_id) { SecureRandom.uuid }
          before(:each) do
            UserFactory.build_from_server($platform, data: {id: user_id}).save!
          end

          it "returns a 201" do
            data = { data: { relationships: { user: { data: { type: "user", id: user_id } } } } }
            post(url, params: data.to_json, headers: $headers)
            expect(response).to have_http_status(:created)
          end

          it "returns the new membership" do
            data = { data: { relationships: { user: { data: { type: "user", id: user_id } } } } }
            post(url, params: data.to_json, headers: $headers)
            expect(json["data"]["relationships"]["user"]["data"]["id"]).to eq(user_id)
            expect(json["data"]["relationships"]["room"]["data"]["id"]).to eq(room_id)
          end
        end

        context "when called with a non-existing user id" do
          let(:inexsistant_user_id) { SecureRandom.uuid }

          it "returns a 404" do
            data     = { data: { relationships: { user: { data: { type: "user", id: inexsistant_user_id } } } } }
            post(url, params: data.to_json, headers: $headers)
            expect(response).to have_http_status(:not_found)
          end

          it "returns a not found error" do
            data     = { data: { relationships: { user: { data: { type: "user", id: inexsistant_user_id } } } } }
            post(url, params: data.to_json, headers: $headers)
            expect(json["errors"].size).to be(1)
          end
        end

        context "when called with a non-existing room id" do
          let(:inexsistant_room_id) { SecureRandom.uuid }

          it "returns a 404" do
            inexsistant_room_url = url.gsub(room_id, inexsistant_room_id)
            post(inexsistant_room_url, params: {}.to_json, headers: $headers)
            expect(response).to have_http_status(:not_found)
          end

          it "returns a not found error" do
            inexsistant_room_url = url.gsub(room_id, inexsistant_room_id)
            post(inexsistant_room_url, params: {}.to_json, headers: $headers)
            expect(json["errors"].size).to be(1)
          end
        end

        context "when the membership already exists" do
          it "returns a 403" do
            data     = { data: { relationships: { user: { data: { type: "user", id: $user.public_id } } } } }
            post(url, params: data.to_json, headers: $headers)
            expect(response).to have_http_status(:forbidden)
          end

          it "returns a forbidden error" do
            data     = { data: { relationships: { user: { data: { type: "user", id: $user.public_id } } } } }
            post(url, params: data.to_json, headers: $headers)
            expect(json["errors"].size).to be(1)
          end
        end
      end
    end
  end
end
