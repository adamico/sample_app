require 'spec_helper'

describe "Users" do
  
  describe "signup" do
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
      visit signin_path
    end

    describe "sign in" do
      context "with invalid email/password" do
        it "should not sign a user in" do
          fill_in :email,       :with => ""
          fill_in :password,    :with => ""
          click_button
          response.should have_selector("div.flash.error", :content => "Invalid")
        end
      end

      context "with valid email/password" do
        it "should sign a user in" do
          fill_in :email,       :with => @user.email
          fill_in :password,    :with => @user.password
          click_button
          controller.should be_signed_in
        end
        it "should enable signing out" do
          fill_in :email,       :with => @user.email
          fill_in :password,    :with => @user.password
          click_button
          click_link "Sign out"
          controller.should_not be_signed_in
        end
      end
    end
  end
end
