class PagesController < ApplicationController
  def home
    if current_user
      @repositories = current_user.repositories(false) # no need to load associations
      render 'dashboard'
    else
      render 'landing', :layout => 'landing'
    end
  end

  def about
  end

  def faq
  end

  def terms
  end

  def privacy
  end
end
