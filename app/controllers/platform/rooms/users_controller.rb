class Platform::Rooms::UsersController < PlatformController
  def index
    room = current_platform.rooms.find_by!(public_id: params[:room_id])
    render json: Platform::UserPresenter.map(room.users)
  end
end
