class RepositoriesController < ApplicationController
  
  # GET /repositories
  def index
    # @repositories = Repository.owned_by(current_user)
    @repositories = Repository.all
  end

  # GET /repositories/1
  def show
    @repository = Repository.find_repository(params[:user_id], params[:id])
  end
end
