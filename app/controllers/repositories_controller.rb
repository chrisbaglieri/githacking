class RepositoriesController < ApplicationController

  before_filter :get_repository, only: [:show, :issues]
  
  # GET /someuser/somerepo
  def show
  end

  def issues
    @tag = params[:tag]
    if @tag and Repository::TAGS.include? @tag
      @issues = @repository.issues[@tag]
    elsif @tag and !Repository::TAGS.include? @tag
      redirect_to(user_repository_issues_path(@repository.owner, @repository.name, Repository::TAGS.first)) and return
    end
  end

  private

  def get_repository
    @repository = Repository.find_or_import(params[:user_id], params[:id] || params[:repository_id])
  rescue ActiveRecord::RecordNotFound
    render(:file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404)
  end
end
