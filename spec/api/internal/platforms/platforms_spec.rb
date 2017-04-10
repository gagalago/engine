require "rails_helper"

RSpec.describe "internal", :internal do
  let(:base_url) { "/internal/platforms" }
  describe "GET platforms/:id" do
    context "when called with a non-existing platform id" do
      let(:platform_id) { SecureRandom.uuid }
      let(:url)         { "#{base_url}/#{platform_id}" }

      it "returns a 404" do
        get(url, headers: $headers)
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found error" do
        get(url, headers: $headers)
        expect(json["errors"].size).to be(1)
      end
    end

    context "when called with a valid platform id" do
      let(:url) { "#{base_url}/#{@platform.id}" }

      before(:each) do
        @platform = PlatformFactory.build(data: { attributes: { name: "Test Platform" } })
        @platform.save!
      end

      it "returns a 200"  do
        get(url, headers: $headers)
        expect(response).to have_http_status(:ok)
      end

      it "returns the expected platform" do
        get(url, headers: $headers)
        expect(json["data"]["id"]).to eq(@platform.id)
      end

      it "returns the platform name" do
        get(url, headers: $headers)
        expect(json["data"]["attributes"]["name"]).to eq(@platform.name)
      end

      it "returns the platform public key" do
        get(url, headers: $headers)
        expect(json["data"]["attributes"]["platformRsaPublic"]).to eq(@platform.platform_rsa_public)
      end

      it "returns the user public key" do
        get(url, headers: $headers)
        expect(json["data"]["attributes"]["userRsaPublic"]).to eq(@platform.user_rsa_public)
      end
    end
  end
end
