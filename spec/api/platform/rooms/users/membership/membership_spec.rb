require "rails_helper"

RSpec.describe "platform", :platform do
  let(:base_url) { "/platform/rooms/:roomId/users/:userId/membership" }
  describe "rooms" do
    let(:room_id) { SecureRandom.uuid }

    before(:each) do
      @room = RoomFactory.build_from_server($platform, data: { id: room_id })
      @room.save!
    end

    describe "users" do
      let(:user_id) { SecureRandom.uuid }

      before(:each) do
        @user = UserFactory.build_from_server($platform, data: { id: user_id })
        @user.save!
      end

      let(:url) { base_url.gsub(":roomId", room_id).gsub(":userId", user_id) }

      describe "POST membership" do
        context "when called with an empty parameters hash" do
          it "returns a 201" do
            post(url, params: {}.to_json, headers: $headers)
            expect(response).to have_http_status(:created)
          end

          it "returns the new membership" do
            post(url, params: {}.to_json, headers: $headers)
            expect(json["data"]["relationships"]["user"]["data"]["id"]).to eq(user_id)
            expect(json["data"]["relationships"]["room"]["data"]["id"]).to eq(room_id)
          end
        end

        context "when called with a non-existing user id" do
          let(:inexsistant_user_id) { SecureRandom.uuid }

          it "returns a 404" do
            inexsistant_user_url = url.gsub(user_id, inexsistant_user_id)
            post(inexsistant_user_url, params: {}.to_json, headers: $headers)
            expect(response).to have_http_status(:not_found)
          end

          it "returns a not found error" do
            inexsistant_user_url = url.gsub(user_id, inexsistant_user_id)
            post(inexsistant_user_url, params: {}.to_json, headers: $headers)
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
            post(url, params: {}.to_json, headers: $headers)
            post(url, params: {}.to_json, headers: $headers)
            expect(response).to have_http_status(:forbidden)
          end

          it "returns a forbidden error" do
            post(url, params: {}.to_json, headers: $headers)
            post(url, params: {}.to_json, headers: $headers)
            expect(json["errors"].size).to be(1)
          end
        end
      end

      describe "DELETE membership" do
        context "when called with a non-existing user id" do
          let(:inexsistant_user_id) { SecureRandom.uuid }

          it "returns a 404" do
            inexsistant_user_url = url.gsub(user_id, inexsistant_user_id)
            delete(inexsistant_user_url, headers: $headers)
            expect(response).to have_http_status(:not_found)
          end

          it "returns a not found error" do
            inexsistant_user_url = url.gsub(user_id, inexsistant_user_id)
            delete(inexsistant_user_url, headers: $headers)
            expect(json["errors"].size).to be(1)
          end
        end

        context "when called with a non-existing room id" do
          let(:inexsistant_room_id) { SecureRandom.uuid }

          it "returns a 404" do
            inexsistant_room_url = url.gsub(room_id, inexsistant_room_id)
            delete(inexsistant_room_url, headers: $headers)
            expect(response).to have_http_status(:not_found)
          end

          it "returns a not found error" do
            inexsistant_room_url = url.gsub(room_id, inexsistant_room_id)
            delete(inexsistant_room_url, headers: $headers)
            expect(json["errors"].size).to be(1)
          end
        end

        context "when the membership already exists" do
          it "returns a 200" do
            post(url, headers: $headers)
            delete(url, headers: $headers)
            expect(response).to have_http_status(:ok)
          end

          it "returns the new membership" do
            post(url, headers: $headers)
            delete(url, headers: $headers)
            expect(json["data"]["relationships"]["user"]["data"]["id"]).to eq(user_id)
            expect(json["data"]["relationships"]["room"]["data"]["id"]).to eq(room_id)
          end
        end

        context "when the membership does not exist" do
          it "returns a 404" do
            delete(url, headers: $headers)
            expect(response).to have_http_status(:not_found)
          end

          it "returns a not found error" do
            delete(url, headers: $headers)
            expect(json["errors"].size).to be(1)
          end
        end
      end
    end
  end
end
