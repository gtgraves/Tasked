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

  def update
    @user = User.find(params[:user_id])
    @list = @user.lists.find(params[:id])
    if @list.update(list_params)
      render json: @list
    else
      render json: { errors: @list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @user = User.find(params[:user_id])
      @list = @user.lists.find(params[:id])
      @list.destroy
      render json: {}, status: :no_content
    rescue ActiveRecord::RecordNotFoundf
      render :json => {}, :status => :not_found
    end
  end

  private
  def list_params
    params.require(:list).permit(:title, :user_id, :private)
  end
end
