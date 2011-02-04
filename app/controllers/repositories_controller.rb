class RepositoriesController < ApplicationController
  
  # GET /repositories
  def index
    # @repositories = Repository.owned_by(current_user)
    @repositories = Repository.all
  end

  # GET /repositories/1
  def show
    @repository = Repository.where(user: params[:user_id], project_name: params[:id]).first
  end
  
end
