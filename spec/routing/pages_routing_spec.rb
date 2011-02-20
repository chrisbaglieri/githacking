require 'spec_helper'

describe PagesController do
  describe 'routing' do
    it 'should route to #home' do
      { get: '' }.should route_to(controller: 'pages', action: 'home')
    end
    
    it 'should route to #home' do
      { get: '/about' }.should route_to(controller: 'pages', action: 'about')
    end
    
    it 'should route to #faq' do
      { get: '/faq' }.should route_to(controller: 'pages', action: 'faq')
    end
    
    it 'should route to #terms' do
      { get: '/terms' }.should route_to(controller: 'pages', action: 'terms')
    end
    
    it 'should route to #privacy' do
      { get: '/privacy' }.should route_to(controller: 'pages', action: 'privacy')
    end
  end
end
