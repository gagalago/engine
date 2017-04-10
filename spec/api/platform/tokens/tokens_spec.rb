require "rails_helper"

RSpec.describe "platform", :platform do
  let(:base_url) { "/platform/users/:user_id/tokens" }

  describe "POST users/:user_id/tokens" do
    let(:user_id) { SecureRandom.uuid }

    before(:each) do
      UserFactory.build_from_server($platform, data: { id: user_id }).save!
    end

    context "when called with an empty parameters hash" do
      it "returns a 201" do
        url = base_url.gsub(":user_id", user_id)
        post(url, headers: $headers)
        expect(response).to have_http_status(:created)
      end

      it "returns the new user" do
        url = base_url.gsub(":user_id", user_id)
        post(url, headers: $headers)
        expect(json["data"]["attributes"]["token"]).not_to be(nil)
      end

      it "returns a token that contains the user_id" do
        url = base_url.gsub(":user_id", user_id)
        post(url, headers: $headers)
        token         = json["data"]["attributes"]["token"]
        token_payload = JWT.decode(token, nil, false)[0]
        expect(token_payload["sub"]).to eq(user_id)
      end

      it "returns a token that contains the platform_id" do
        url           = base_url.gsub(":user_id", user_id)
        post(url, headers: $headers)
        token         = json["data"]["attributes"]["token"]
        token_payload = JWT.decode(token, nil, false)[0]
        expect(token_payload["data"]["platformId"]).to eq($platform.id)
      end
    end
  end
end
