require "spec_helper"

describe RepositoriesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/repositories" }.should route_to(:controller => "repositories", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/repositories/new" }.should route_to(:controller => "repositories", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/repositories/1" }.should route_to(:controller => "repositories", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/repositories/1/edit" }.should route_to(:controller => "repositories", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/repositories" }.should route_to(:controller => "repositories", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/repositories/1" }.should route_to(:controller => "repositories", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/repositories/1" }.should route_to(:controller => "repositories", :action => "destroy", :id => "1")
    end

  end
end
