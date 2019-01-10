class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create

  def create
      github = GithubService.new
      #retrieve session token
      session[:token] = github.authenticate!(ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_SECRET'], params[:code])

      #retreive user name
      session[:user_name] = github.get_username

      redirect_to root_path
    end

  end
