require 'spec_helper'

describe Relationship do
  let(:follower) {Factory(:user)}
  let(:followed) {Factory(:user)}

  subject { follower.relationships.build }

  it { should respond_to(:followed) } 
  it { should respond_to(:follower) } 

  it "should build a valid relationship given valid attributes" do
    subject.followed_id = followed.id
    subject.should be_valid
  end

  it "should have the right follower" do
    subject.follower.should == follower
  end
  it "should have the right followed user" do
    subject.followed_id = followed.id
    subject.followed.should == followed
  end
end
