def test_sign_in(user)
  controller.current_user = user
end

def integration_sign_in(user)
  visit signin_path
  fill_in :email, :with => user.email
  fill_in :password, :with => user.password
  click_button
end
