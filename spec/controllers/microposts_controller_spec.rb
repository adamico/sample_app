require 'spec_helper'

describe MicropostsController do
  render_views

  describe "#authenticate" do
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    context "failure" do
      let(:invalid_content) { {:content => ""} }
      it "should not create a micropost" do
        expect do
          post :create, :micropost => invalid_content
        end.should_not change(Micropost, :count)
      end
      it "should render the home page" do
        post :create, :micropost => invalid_content
        response.should render_template('pages/home')
      end
    end

    context "success" do
      it "should create a micropost" do
        lambda do
          post :create, :micropost => { :content => "Lorem ipsum"}
        end.should change(Micropost, :count).by(1)
      end
      it "should redirect to the home page" do
        post :create, :micropost => { :content => "Lorem ipsum"}
        response.should redirect_to(root_path)
      end
      it "should have a flash message" do
        post :create, :micropost => { :content => "Lorem ipsum"}
        flash[:success].should =~ /micropost created/i
      end
    end
  end

  describe "DELETE 'destroy'" do
    context "for an unauthorized user" do
      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user)
        test_sign_in(wrong_user)
        @micropost = Factory(:micropost, :user => @user)
      end

      it "should deny access" do
        delete :destroy, :id => @micropost
        response.should redirect_to(root_path)
      end
    end

    context "for an authorised user" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @micropost = Factory(:micropost, :user => @user)
      end
      it "should destroy the micropost" do
        expect do
          delete :destroy, :id => @micropost
        end.should change(Micropost, :count).by(-1)
      end
    end
  end
end
