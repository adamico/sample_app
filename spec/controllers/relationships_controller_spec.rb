require 'spec_helper'

describe RelationshipsController do
  describe "access control" do
    it "should require signin for create" do
      post :create
      response.should redirect_to(signin_path)
    end
    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
      @followed = Factory(:user)
    end
    it "should create a relationship" do
      expect do
        post :create, :relationship => { :followed_id => @followed}
      end.should change(Relationship, :count).by(1)
    end
    it "should create a relationship using Ajax" do
      expect do
        xhr :post, :create,
          :relationship => { :followed_id => @followed}
      end.should change(Relationship, :count).by(1)
    end
    it "should redirect to the followed user page" do
      post :create, :relationship => { :followed_id => @followed}
      response.should be_redirect
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      user = test_sign_in(Factory(:user))
      followed = Factory(:user)
      user.follow!(followed)
      @relationship = user.relationships.find_by_followed_id(followed)
    end
    it "should destroy a relationship" do
      expect do
        delete :destroy, :id => @relationship
      end.should change(Relationship, :count).by(-1)
    end
    it "should destroy a relationship using Ajax" do
      expect do
        xhr :delete, :destroy, :id => @relationship
      end.should change(Relationship, :count).by(-1)
    end
    it "should redirect to the unfollowed user page" do
      delete :destroy, :id => @relationship
      response.should be_redirect
    end
  end
end
