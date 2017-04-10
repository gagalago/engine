require "rails_helper"

RSpec.describe "internal", :internal do
  let(:base_url) { "/internal/send-unread-messages" }
  describe "POST /send-unread-messages" do
    it "returns a 202"  do
      allow(UnreadMessagesWorker).to receive(:perform_async)
      post(base_url, headers: $headers)
      expect(response).to have_http_status(:accepted)
    end

    it "queues a unread messages worker"  do
      allow(UnreadMessagesWorker).to receive(:perform_async)
      post(base_url, headers: $headers)
      expect(UnreadMessagesWorker).to have_received(:perform_async)
    end
  end
end
