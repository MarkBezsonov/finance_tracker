class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: friend.id)
    if current_user.save
      flash[:notice] = "You are now friends with #{friend.full_name}."
    else
      flash[:alert] = "Oops! Something went wrong with your tracking request."
    end
    redirect_to my_friends_path
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    flash[:notice] = "You have removed this user from your friends list."
    redirect_to my_friends_path
  end
end
