class Internal::PlatformsController < InternalController
  def show
    platform = Platform.find(params[:id])
    render json: Internal::PlatformPresenter.new(platform)
  end
end
