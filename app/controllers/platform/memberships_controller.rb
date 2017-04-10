class Platform::MembershipsController < PlatformController

  def create
    membership = MembershipService.add_membership_from_server(current_platform, params)
    render json: Platform::MembershipPresenter.new(membership), status: :created
  rescue ActiveRecord::RecordNotUnique
    render json: {
      errors: [
        {
          status: 403,
          title:  "Membership already exists",
          code:   "membership_already_exists"
        }
      ]
    }, status: :forbidden
  end

  def destroy
    user_public_id = params[:user_id]
    room_public_id = params[:room_id]
    membership = MembershipService.destroy_membership(current_platform, user_public_id, room_public_id)
    render json: Platform::MembershipPresenter.new(membership)
  end
end
