class PagesController < ApplicationController
  def home
    if current_user
      @repositories = current_user.repositories
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
