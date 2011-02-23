class MetadataController < ApplicationController
  def new
  end

  def create
    send_file Repository::Metadata.new(params[:metadata]).to_file, type: 'application/x-yaml'
  end

  def edit
  end

end
