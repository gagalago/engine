require "rails_helper"

RSpec.describe "internal", :internal do
  let(:base_url) { "/internal/refresh-statuses" }
  describe "POST /refresh-statuses" do
    it "returns a 202"  do
      allow(StatusWorker).to receive(:perform_async)
      post(base_url, headers: $headers)
      expect(response).to have_http_status(:accepted)
    end

    it "queues a status worker"  do
      allow(StatusWorker).to receive(:perform_async)
      post(base_url, headers: $headers)
      expect(StatusWorker).to have_received(:perform_async)
    end
  end
end
