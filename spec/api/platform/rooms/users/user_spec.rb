require "rails_helper"

RSpec.describe "platform", :platform do
  describe "rooms" do
    let(:base_url) { "/platform/rooms/:room_id/users" }
    let(:room_id)  { SecureRandom.uuid }
    let(:url)      { base_url.gsub(":room_id", room_id) }

    before :each do
      @room = RoomFactory.build_from_server($platform, data: {id: room_id}).save!
    end

    describe "GET users" do
      context "when there are no users in the room" do
        it "returns a 200" do
          get(url, headers: $headers)
          expect(response).to have_http_status(:ok)
        end

        it "returns a user count of 0" do
          get(url, headers: $headers)
          expect(json["meta"]["count"]).to eq(0)
        end

        it "returns an empty user list" do
          get(url, headers: $headers)
          expect(json["data"].size).to eq(0)
        end
      end

      context "when there are 10 users in the room" do
        before do
          1.upto(10) do
            user = UserFactory.build_from_server($platform, {})
            user.save!
            MembershipFactory.build_from_server($platform, user_id: user.public_id, room_id: room_id).save!
          end
        end

        it "returns a 200" do
          get(url, headers: $headers)
          expect(response).to have_http_status(:ok)
        end

        it "returns a user count of 10" do
          get(url, headers: $headers)
          expect(json["meta"]["count"]).to eq(10)
        end

        it "returns a list with 10 users" do
          get(url, headers: $headers)
          expect(json["data"].size).to eq(10)
        end
      end
    end
  end
end
