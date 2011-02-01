class RepositoriesController < ApplicationController
  
  # GET /repositories
  def index
    # @repositories = Repository.owned_by(current_user)
    @repositories = Repository.all
  end

  # GET /repositories/1
  def show
    @repository = Repository.find(params[:id])
  end

  # GET /repositories/new
  def new
    @repository = Repository.new
  end

  # GET /repositories/1/edit
  def edit
    @repository = Repository.find(params[:id])
  end

  # POST /repositories
  def create
    @repository = Repository.new(params[:repository])
    
    if @repository.save
      redirect_to(@repository, :notice => 'Repository was successfully created.')
    else
      render :action => "new"
    end
  end

  # PUT /repositories/1
  def update
    @repository = Repository.find(params[:id])

    if @repository.update_attributes(params[:repository])
      redirect_to(@repository, :notice => 'Repository was successfully updated.')
    else
      render :action => "edit"
    end
  end

  # DELETE /repositories/1
  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy

    redirect_to(repositories_url)
  end
  
  def search
    @repositories = Repository.all
  end
end
