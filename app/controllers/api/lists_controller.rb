class Api::ListsController < ApiController
  before_action :authenticated?

  def create
    @user = User.find(params[:user_id])
    @list = @user.lists.build(list_params)
    if @list.save
      render json: @list
    else
      render json: { errors: @list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def list_params
    params.require(:list).permit(:title, :user_id, :private)
  end
end
