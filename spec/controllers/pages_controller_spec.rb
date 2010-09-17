require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    context "when not signed in" do
      it "should be successful" do
        get :home
        response.should be_success
      end

      it "should have the right title" do
        get :home
        response.should have_selector("title",
          :content => @base_title + " | Home")
      end
    end

    context "when signed in" do
      let(:user) {test_sign_in(Factory(:user))}
      let(:other_user) { Factory(:user)}
      before(:each) do
        other_user.follow!(user)
      end

      it "should have the right following counts" do
        get :home
        response.should have_selector("a",
          :href => following_user_path(user),
          :content => "0 following")
      end

      it "should have the right followers counts" do
        get :home
        response.should have_selector("a",
          :href => followers_user_path(user),
          :content => "1 followers")
      end
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
        :content => @base_title + " | Contact")
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end

    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
        :content => @base_title + " | About")
    end
  end

  describe "GET 'help'" do
    it "should be successful" do
      get 'help'
      response.should be_success
    end

    it "should have the right title" do
      get 'help'
      response.should have_selector("title",
        :content => @base_title + " | Help")
    end
  end
end
