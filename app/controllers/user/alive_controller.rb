class User::AliveController < UserController
  def update
    current_user.alive!
    render json: User::AlivePresenter.new
  end
end
