class HomeController < ApplicationController
  def index
    render json: { myNameIs: "Babili", iAm: "a chat" }, status: :ok
  end
end
