require "rails_helper"

RSpec.describe "platform", :platform do
  let(:base_url) { "/platform/users" }

  describe "GET users" do
    context "when there are no users" do
      it "returns a 200" do
        get(base_url, headers: $headers)
        expect(response).to have_http_status(:ok)
      end

      it "returns a user count of 0" do
        get(base_url, headers: $headers)
        expect(json["meta"]["count"]).to eq(0)
      end

      it "returns an empty user list" do
        get(base_url, headers: $headers)
        expect(json["data"].size).to eq(0)
      end
    end

    context "when there are 200 users" do
      before do
        1.upto(200) do
          UserFactory.build_from_server($platform, {}).save!
        end
      end

      it "returns a 200" do
        get(base_url, headers: $headers)
        expect(response).to have_http_status(:ok)
      end

      it "returns a user count of 200" do
        get(base_url, headers: $headers)
        expect(json["meta"]["count"]).to eq(200)
      end

      it "returns a list with 200 users" do
        get(base_url, headers: $headers)
        expect(json["data"].size).to eq(200)
      end
    end
  end

  describe "POST users" do
    context "when called with an empty parameters hash" do
      it "returns a 201" do
        post(base_url, params: {}.to_json, headers: $headers)
        expect(response).to have_http_status(:created)
      end

      it "returns the new user" do
        post(base_url, params: {}.to_json, headers: $headers)
        expect(json["data"]["id"]).not_to be(nil)
      end
    end

    context "when called with a non-existing user id" do
      let(:user_id) { SecureRandom.uuid }

      it "returns a 201" do
        data = { data: { id: user_id } }
        post(base_url, params: data.to_json, headers: $headers)
        expect(response).to have_http_status(:created)
      end

      it "returns the new user" do
        data = { data: { id: user_id } }
        post(base_url, params: data.to_json, headers: $headers)
        expect(json["data"]["id"]).to eq(user_id)
      end
    end

    context "when called with an existing user id" do
      let(:user_id) { SecureRandom.uuid }

      before(:each) do
        UserFactory.build_from_server($platform, data: { id: user_id }).save!
      end

      it "returns a 403" do
        data = { data: { id: user_id } }
        post(base_url, params: data.to_json, headers: $headers)
        expect(response).to have_http_status(:forbidden)
      end

      it "returns an error message in the payload" do
        data = { data: { id: user_id } }
        post(base_url, params: data.to_json, headers: $headers)
        expect(json["errors"].size).to be(1)
      end
    end
  end

  describe "PUT users" do
    context "when called with an existing user id" do
      let(:user_id)      { SecureRandom.uuid }
      let (:new_user_id) { SecureRandom.uuid }

      before(:each) do
        UserFactory.build_from_server($platform, data: { id: user_id }).save!
      end

      it "returns a 200" do
        url  = "#{base_url}/#{user_id}"
        data = { data: { id: new_user_id } }
        put(url, params: data.to_json, headers: $headers)
        expect(response).to have_http_status(:ok)
      end

      it "returns the new user id" do
        url  = "#{base_url}/#{user_id}"
        data = { data: { id: new_user_id } }
        put(url, params: data.to_json, headers: $headers)
        expect(json["data"]["id"]).to eq(new_user_id)
      end
    end

    context "when called with a non-existing user id" do
      let(:user_id) { SecureRandom.uuid }

      it "returns a 404" do
        url = "#{base_url}/#{user_id}"
        put(url, headers: $headers)
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found error" do
        url = "#{base_url}/#{user_id}"
        put(url, headers: $headers)
        expect(json["errors"].size).to be(1)
      end
    end
  end

  describe "DELETE users" do
    context "when called with no user id" do
      it "returns a 404" do
        delete(base_url, headers: $headers)
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found error" do
        delete(base_url, headers: $headers)
        expect(json["errors"].size).to be(1)
      end
    end

    context "when called with a non-existing user id" do
      let(:user_id) { SecureRandom.uuid }

      it "returns a 404" do
        url = "#{base_url}/#{user_id}"
        delete(url, headers: $headers)
        expect(response).to have_http_status(:not_found)
      end

      it "returns a not found error" do
        url = "#{base_url}/#{user_id}"
        delete(url, headers: $headers)
        expect(json["errors"].size).to be(1)
      end
    end

    context "when called with a valid user id" do
      let(:user_id) { SecureRandom.uuid }

      before(:each) do
        UserFactory.build_from_server($platform, data: { id: user_id }).save!
      end

      it "returns a 200"  do
        url = "#{base_url}/#{user_id}"
        delete(url, headers: $headers)
        expect(response).to have_http_status(:ok)
      end

      it "destroys the user in the database" do
        url = "#{base_url}/#{user_id}"
        delete(url, headers: $headers)
        expect($platform.users.reload.size).to eq(0)
      end

      it "returns the deleted user" do
        url = "#{base_url}/#{user_id}"
        delete(url, headers: $headers)
        expect(json["data"]["id"]).to eq(user_id)
      end
    end
  end
end
