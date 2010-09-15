require 'spec_helper'

describe "Microposts" do
  before(:each) do
    @user = Factory(:user)
    @other_user = Factory(:user)
    integration_sign_in(@user)
  end

  describe "accessing microposts from user resource" do
    before(:each) do
      2.times{@user.microposts.create(:content => "content")}
      2.times{@other_user.microposts.create(:content => "other content")}
    end
    
    context "when visiting current_user profile" do
      it "should list current_user's microposts" do
        visit user_microposts_path(@user)
        response.should have_selector("ul.microposts")
        response.should have_selector("span.content", :content => "content")
      end
    end
    context "when visiting another user profile" do
      it "should list his microposts" do
        visit user_microposts_path(@other_user)
        response.should have_selector("ul.microposts")
        response.should have_selector("span.content", :content => "other content")
      end
    end
  end

  describe "delete links" do
    before(:each) do
      2.times do
        @user.microposts.create(:content => "value for content")
        @other_user.microposts.create(:content => "value for content")
      end
    end
    context "when visiting other users' pages" do
      it "should not appear" do
        visit user_path(@other_user)
        response.should_not have_selector("a", :content => "delete")
      end
    end
    context "when visiting one's own profile" do
      it "should appear" do
        visit user_path(@user)
        response.should have_selector("a", :content => "delete")
      end
    end
  end

  describe "creation" do
    context "failure" do
      it "should not make a new micropost" do
        expect do
          visit root_path
          fill_in :micropost_content, :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end

    context "success" do
      it "should make a new micropost" do
        content = "Lorem ipsum dolor sit amet"
        expect do
          visit root_path
          fill_in :micropost_content, :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end
end
