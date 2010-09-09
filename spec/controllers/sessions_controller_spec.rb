require 'spec_helper'

describe SessionsController do
  render_views

  before(:each) do
    get :new
  end

  describe "GET 'new'" do
    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector("title", :content => "Sign in")
    end
  end

  describe "POST 'create'" do
    
    context "invalid signin" do
      before(:each) do
        attr = { :email => "email@example.com", :password => "invalid"}
        post :create, :session => attr
      end

      it "should re-render the new page" do
        response.should render_template('new')
      end

      it "should have the right title" do
        response.should have_selector("title", :content => "Sign in")
      end

      it "should have a flash.now message" do
        flash.now[:error].should =~ /invalid/i
      end
    end

    context "with valid email and password" do
    
      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password}
      end

      it "should sign the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end

      it "should redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
    
    end
  end

  describe "DELETE 'destroy'" do
    
    it "should sign a user out" do
      test_sign_in(Factory(:user))
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end

end
