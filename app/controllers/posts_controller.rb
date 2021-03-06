# frozen_string_literal: true

class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params.merge(user_id: current_user.id)) # could be a source of bugs
    redirect_to posts_url
  end

  def edit
    if Post.verify_user(current_user, Post.find(params[:id])) && ((Time.now - Post.find(params[:id]).created_at) / 1.minute <= 10)

      @post = Post.find(params[:id])
    else
      flash_error
      redirect_to posts_url
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      redirect_to posts_url
    else
      render 'edit'
    end
  end

  def index
    @posts = Post.order(created_at: :desc)
  end

  def destroy
    if Post.verify_user(current_user, Post.find(params[:id]))
      @post = Post.find(params[:id])
      @post.destroy
    else
      flash[:error] = "You must unlearn what you have learned."
    end
    redirect_to posts_url
  end

  private

  def post_params
    params.require(:post).permit(:message)
  end

  def flash_error
    if Post.verify_user(current_user, Post.find(params[:id])) == false
      flash[:error] = "You will find only what you bring in"
    else
      flash[:error] = "The dark side clouds everything. Impossible to change the past 10 minutes is."
    end
  end
end
