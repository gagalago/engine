class Platform::RoomsController < PlatformController
  def index
    room_ids       = params[:room_ids]
    rooms_per_page = params[:per_page].try(:to_i) || Room::PER_PAGE
    rooms          = current_platform.rooms.includes(:users)

    if params[:first_seen_room_id]
      first_seen_room = current_platform.rooms.find_by!(public_id: params[:first_seen_room_id])
    end

    if room_ids
      rooms      = rooms.where(public_id: room_ids)
      room_count = rooms.count
      errors      = render_not_found_ids_messages(room_ids, rooms)
      return render json: { errors:  errors }, status: :not_found if errors.any?
    else
      room_count = rooms.count
      rooms      = rooms.before_room(rooms_per_page, first_seen_room)
    end

    render json: Platform::RoomPresenter.map(
      rooms:      rooms,
      room_count: room_count
    )
  end

  def show
    room = current_platform.rooms.find_by!(public_id: params[:id])
    render json: Platform::RoomPresenter.new(room)
  end

  def create
    Room.transaction do
      room = RoomFactory.build_from_server(current_platform, params)
      room.save!
      render json: Platform::RoomPresenter.new(room), status: :created
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { errors: [
      {
        status: 403,
        title:  "Room id already exists",
        code:   "id_already_exists",
        source: { parameter: "roomId" }
      }
    ] }, status: :forbidden
  end

  def update
    room = current_platform.rooms.find_by!(public_id: params[:id])
    RoomFactory.update_from_server(room, params)
    room.save!
    render json: Platform::RoomPresenter.new(room)
  end

  def destroy
    room = current_platform.rooms.find_by!(public_id: params[:id])
    room.destroy!
    render json: Platform::RoomPresenter.new(room)
  end

  private

  def render_not_found_ids_messages(room_ids, rooms)
    not_found_ids = room_ids - rooms.map(&:public_id)
    not_found_ids.map do |id|
      {
        title:  "Room not found",
        status: 404,
        code:   "not_found",
        source: { parameter: "roomId" }
      }
    end
  end
end
