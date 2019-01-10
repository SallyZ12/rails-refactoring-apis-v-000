class RepositoriesController < ApplicationController

  def index
    access_hash = {'access_token' => session[:token]}
    github = GithubService.new(access_hash)
    @repo_data = github.get_repos
  end


  def create
      access_hash = {'access_token' => session[:token]}
      github = GithubService.new(access_hash)
      github.create_repo(params[:name])

      redirect_to '/'
  end

end
