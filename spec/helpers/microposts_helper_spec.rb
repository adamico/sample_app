require 'spec_helper'

include MicropostsHelper
describe "wrap" do
  it "should append zero width spaces to strings longer than 30 characters" do
    char = "a"
    content = char * 31
    helper.wrap(content).should == char * 30 + "&#8203;" + char
  end
  it "should do nothing to strings lower or equal to 30 characters" do
    content = "a" * 30
    helper.wrap(content).should == content
  end
end
