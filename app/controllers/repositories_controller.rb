class RepositoriesController < ApplicationController
  
  # GET /repositories
  def index
    # @repositories = Repository.owned_by(current_user)
    @repositories = Repository.all
  end

  # GET /repositories/1
  def show
    begin
      @repository = Repository.find_repository(params[:user_id], params[:id])
    rescue ActiveRecord::RecordNotFound
      render(:file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404)
    end
  end
end
