require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
      get :show, :id => @user
    end

    it "should be successful" do
      response.should be_success
    end

    it "should find the right user" do
      assigns(:user).should == @user
    end

    it "should have the right title" do
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      response.should have_selector("h1>img", :class => "gravatar")
    end

    context "when user#microposts count is > 0" do
      it "should show the user's microposts" do
        mp1 = Factory(:micropost, :user => user, :content => "Foo bar")
        mp2 = Factory(:micropost, :user => user, :content => "Baz quux")
        get :show, :id => user
        response.should have_selector("span.content", :content => mp1.content)
        response.should have_selector("span.content", :content => mp2.content)
      end
    end
  end

  describe "GET 'new'" do
    context "with a user signed-in" do
      it "should protect the page" do
        test_sign_in(Factory(:user))
        get :new
        response.should redirect_to(root_path)
      end
    end

    context "with no user signed-in" do
      before(:each) do
        get :new
      end
        it "should be successful" do
          response.should be_success
        end
        it "should have the right title" do
          response.should have_selector("title", :content => "Sign up")
        end
    end
  end

  describe "POST 'create'" do
    context "with a user signed-in" do
      it "should protect the page" do
        test_sign_in(Factory(:user))
        post :create, :user => { :name => "", :email => "", :password => "", :password_confirmation => ""}
      end
    end
    context "with no user signed-in" do
      context "failure" do
        before(:each) do
          @attr = { :name => "", :email => "", :password => "", :password_confirmation => ""}
        end

        it "should not create a user" do
          lambda do
            post :create, :user => @attr
          end.should_not change(User, :count)
        end

        it "should have the right title" do
          post :create, :user => @attr
          response.should have_selector("title", :content => "Sign up")
        end

        it "should render the 'new page'" do
          post :create, :user => @attr
          response.should render_template('new')
        end
      end

      context "success" do
        before(:each) do
          @attr = { :name => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar" }
        end

        it "should create a user" do
          lambda do
            post :create, :user => @attr
          end.should change(User, :count).by(1)
        end

        it "should redirect to the user show page" do
          post :create, :user => @attr
          response.should redirect_to(user_path(assigns(:user)))
        end

        it "should have a welcome message" do
          post :create, :user => @attr
          flash[:success].should =~ /welcome to the sample app/i
        end

        it "should sign the user in" do
          post :create, :user => @attr
          controller.should be_signed_in
        end
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
      get :edit, :id => @user
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the Gravatar" do
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url, :content => "change")
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    context "failure" do
      before(:each) do
        put :update, :id => @user, :user => { 
          :name => "", 
          :email => "", 
          :password => "", 
          :password_confirmation => ""}
      end

      it "should render the 'edit' page" do
        response.should render_template('edit')
      end

      it "should have the right title" do
        response.should have_selector("title", :content => "Edit user")
      end
    end

    context "success" do
      before(:each) do
        put :update, :id => @user, :user => {
          :name => "New User",
          :email => @user.email,
          :password => @user.password,
          :password_confirmation => @user.password }
      end

      it "should change the user's attributes" do
        user = assigns(:user)
        @user.reload
        @user.name.should == user.name
      end

      it "should redirect to the user show page" do
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        flash[:success].should =~ /updated/i
      end
    end
  end

  describe "authentication of edit/update pages" do
    
    before(:each) do
      @user = Factory(:user)
    end

    context "for guest users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end
      it "should deny access to 'update'" do
        put :update, :id => @user
        response.should redirect_to(signin_path)
      end
      it "should have a 'please sign in' flash" do
        get :edit, :id => @user
        flash[:notice].should =~ /please sign in/i
      end
    end

    context "for signed_in users" do
      
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      it "should require matching users for 'update'" do
        put :update, :id => @user
        response.should redirect_to(root_path)
      end
    end
  end

  describe "GET 'index'" do
    
    context "for non-signed_in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    context "for signed-in users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user)
        third = Factory(:user)
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user)
        end
        get :index
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title", :content => "All users")
      end

     it "should have an element for each user" do
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end 

      it "should paginate users" do
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                     :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                     :content => "Next")
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @user = Factory(:user)
    end

    context "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    context "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    context "as an admin user" do
      
      before(:each) do
        admin = Factory(:user)
        admin.toggle!(:admin)
        test_sign_in(admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end

      it "should have a 'destroyed 'flash a message" do
        delete :destroy, :id => @user
        flash[:success].should =~ /destroyed/i
      end
    end
  end
end
