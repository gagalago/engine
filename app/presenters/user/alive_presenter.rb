class User::AlivePresenter < BasePresenter
  def initialize
  end

  def data
    {
      type: "alive"
    }
  end
end
