require 'spec_helper'

describe PagesController do
  before do
    request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("githacker:point65")
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'faq'" do
    it "should be successful" do
      get 'faq'
      response.should be_success
    end
  end

  describe "GET 'terms'" do
    it "should be successful" do
      get 'terms'
      response.should be_success
    end
  end

end
