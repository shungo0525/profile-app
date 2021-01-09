class UsersController < ApplicationController
  def sign_up
    user = User.new(user_params)
    if user.save
      render json: { status: '200', data: user }
    else
      render json: { status: '400', data: user.errors.full_messages }
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      render json: { status: '200', data: user }
    else
      render json: { status: '401' }
    end
  end

  def index
    users = User.all
    # render :json { users: users }
    render :json => { users: users }
  end

  def show
  end

  private

    def user_params
      params.permit(:email, :password)
    end
end
