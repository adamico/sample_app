require 'spec_helper'

describe "Microposts" do
  before(:each) do
    user = Factory(:user)
    integration_sign_in(user)
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
