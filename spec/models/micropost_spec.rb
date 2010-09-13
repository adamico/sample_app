require 'spec_helper'

describe Micropost do
  let(:user) { Factory(:user) }
  let(:micropost) { Factory.build(:micropost, :user => user)}

  subject { micropost }
  it { should be_valid }

  it "should have a user attribute" do
    subject.should respond_to(:user)
  end

  it "should have the right associated user" do
    subject.user.should == user
  end
end
