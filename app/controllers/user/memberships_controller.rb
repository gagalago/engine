class User::MembershipsController < UserController
  def create
    membership = MembershipService.add_membership_from_client(current_platform, current_user, params)
    render json: User::MembershipPresenter.new(
      membership: membership,
      messages_per_room: 0,
      current_user: current_user
    ), status: :created
  rescue ActiveRecord::RecordNotUnique
    render json: {
      errors: [
        { status: 403, title: "Membership already exist", code: "membership_already_exists" }
      ]
    }, status: :forbidden
  end
end
