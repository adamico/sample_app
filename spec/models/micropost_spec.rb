require 'spec_helper'

describe Micropost do
  let(:user) { Factory(:user)}

  subject { user.microposts.build(:content => "value for content") }

  # Validations
  it "should require a user id" do
    subject.user_id = nil
    subject.should_not be_valid
  end

  it "should require a nonblank content" do
    subject.content = ""
    subject.should_not be_valid
  end

  it "should reject long content" do
    subject.content = "a" * 141
    subject.should_not be_valid
  end

  describe ".from_users_followed_by" do
    let(:other_user) {Factory(:user)}
    let(:third_user) {Factory(:user)}

    before(:each) do
      @user_post = Factory(:micropost, :user => user)
      @other_post = Factory(:micropost, :user => other_user)
      @third_post = Factory(:micropost, :user => third_user)
    end

    subject {Micropost.from_users_followed_by(user)}
    it "should exist" do
      Micropost.should respond_to(:from_users_followed_by)
    end
    it "should include the user's own microposts" do
      subject.include?(@user_post).should be_true
    end
    it "should include the followed user's microposts" do
      user.follow!(other_user)
      subject.include?(@other_post).should be_true
    end
    it "should not include an unfollowed user's microposts" do
      subject.include?(@third_post).should be_false
    end
  end

end
