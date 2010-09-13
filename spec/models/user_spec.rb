require 'spec_helper'

describe User do
  
  subject { Factory.create(:user) }

  it { should be_valid }

  it "should require a name" do
    subject.name = ""
    subject.should_not be_valid
  end
  it "should require an email address" do
    subject.email = ""
    subject.should_not be_valid
  end
  it "should reject names that are too long" do
    long_name = "a" * 51
    subject.name = long_name
    subject.should_not be_valid
  end
  it "should accept valid email addresses" do
    addresses = %w(user@foo.com THE_USER@foo.bar.org first.last@foo.jp)
    addresses.each do |address|
      subject.email = address
      subject.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w(user@foo,com user_at_foo.org exampe.user@foo.)
    addresses.each do |address|
      subject.email = address
      subject.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database.
    new_user = Factory.build(:user, :email => subject.email)
    new_user.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = subject.email.upcase
    new_user = Factory.build(:user, :email => upcased_email)
    new_user.should_not be_valid
  end

  it "should have an encrypted password attribute" do
    subject.should respond_to(:encrypted_password)
  end

  describe ".authenticate" do
    it "finds the user given email and password" do
      subject.class.authenticate(subject.email, subject.password).should == subject
    end
  end

  describe ".authenticate_with_salt" do
    it "finds the user given id and cookie_salt" do
      subject.class.authenticate_with_salt(subject.id, subject.salt) == subject
    end
  end

  describe "password validations" do
    it "should require a password" do
      subject.password, subject.password_confirmation = "", ""
      subject.should_not be_valid
    end
    it "should require a matching password confirmation" do
      subject.password_confirmation = "invalid"
      subject.should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      subject.password, subject.password_confirmation = short, short
      subject.should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      subject.password, subject.password_confirmation = long, long
      subject.should_not be_valid
    end
  end

  describe "#admin" do
    it "should exist" do
      subject.should respond_to(:admin)
    end

    it "should not be true by default" do
      subject.should_not be_admin
    end
    it "should be toggable" do
      subject.toggle!(:admin)
      subject.should be_admin
    end
  end

  describe "#microposts" do
    it "should exist" do
      subject.should respond_to(:microposts)
    end
    it "should list associated microposts newest first" do
      mp1 = Factory(:micropost, :user => subject)
      mp2 = Factory(:micropost, :user => subject)
      subject.microposts.should == [mp2, mp1]
    end
  end
end
