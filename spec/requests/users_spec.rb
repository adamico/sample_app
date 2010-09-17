require 'spec_helper'

describe "Users" do
  
    context "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",           :with => ""
          fill_in "Email",          :with => ""
          fill_in "Password",       :with => ""
          fill_in "Confirmation",   :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    context "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
            fill_in "Name",           :with => "Example User"
            fill_in "Email",          :with => "user@example.com"
            fill_in "Password",       :with => "foobar"
            fill_in "Confirmation",   :with => "foobar"
            click_button
            response.should have_selector("div.flash.success",
                                         :content => "Welcome")
            response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in and out" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "sign in" do
      context "with invalid email/password" do
        it "should not sign a user in" do
          visit signin_path
          fill_in :email,       :with => ""
          fill_in :password,    :with => ""
          click_button
          response.should have_selector("div.flash.error", :content => "Invalid")
        end
      end

      context "with valid email/password" do
        before(:each) do
          integration_sign_in(@user)
        end
        it "should sign a user in" do
          controller.should be_signed_in
        end
        it "should enable signing out" do
          click_link "Sign out"
          controller.should_not be_signed_in
        end
      end
    end
  end

  describe "destroying users" do
    before(:each) do
      @user = Factory(:user)
    end
    context "when user is an admin" do
      let(:admin) {Factory(:user, :admin => true)}

      before(:each) do
        integration_sign_in(admin)
        visit users_path
      end
      it "should show links to destroy users" do
        response.should have_selector("a", :href => "/users/#{@user.id}", "data-confirm" => "Are you sure?", "data-method" => "delete", :title => "Delete #{@user.name}", :content => "delete")
      end
      it "should hide link to destroy himself" do
        response.should_not have_selector("a", :href => "/users/#{admin.id}", "data-confirm" => "Are you sure?", "data-method" => "delete", :title => "Delete #{admin.name}", :content => "delete")
      end
    end
    context "when user is not admin" do
      it "should not show links to destroy users" do
        integration_sign_in(@user)
        visit users_path
        response.should_not have_selector("a", :href => "/users/#{@user.id}", "data-confirm" => "Are you sure?", "data-method" => "delete", :title => "Delete #{@user.name}", :content => "delete")
      end
    end
  end
end
