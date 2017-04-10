class User::UserController < UserController
  def show
    render json: User::MePresenter.new(current_user)
  end
end
