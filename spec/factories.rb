Factory.define :user do |f|
  f.sequence(:name) {|n| "user#{n}"}
  f.email {|user| "#{user.name}@example.com".downcase}
  f.password              "foobar"
  f.password_confirmation "foobar"
end
