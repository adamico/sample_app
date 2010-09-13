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

end
