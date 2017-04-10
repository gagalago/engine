class Platform::UsersController < PlatformController
  def index
    users = current_platform.users
    render json: Platform::UserPresenter.map(users)
  end

  def create
    user = UserFactory.build_from_server(current_platform, params)
    user.save!
    render json: Platform::UserPresenter.new(user), status: :created
  rescue ActiveRecord::RecordNotUnique
    render json: {
      errors: [
        {
          status: 403,
          title:  "User id already exists",
          code:   "already_exists",
          source: { parameter: "userId" }
        }
      ]
    }, status: :forbidden
  end

  def update
    user = current_platform.users.find_by!(public_id: params[:id])
    UserFactory.update_from_server(user, params)
    user.save!
    render json: Platform::UserPresenter.new(user)
  end

  def destroy
    user = current_platform.users.find_by!(public_id: params[:id])
    user.destroy!
    render json: Platform::UserPresenter.new(user)
  end
end
