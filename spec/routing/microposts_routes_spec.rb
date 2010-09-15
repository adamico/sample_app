require 'spec_helper'

describe "nesting microposts in users" do
  it "routes /users/:id/microposts to microposts#index" do
    { :get => "users/1/microposts" }.should route_to(
      :controller => "microposts",
      :action => "index",
      :user_id => "1"
    )
  end
end
