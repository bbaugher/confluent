source "https://supermarket.getchef.com"

metadata

group "test" do
  cookbook "confluent_tester", path: "test/cookbooks/confluent_tester"

  # There is an issue where java won't install correctly without doing an apt-update in our tests
  cookbook "apt", "~> 2.4"
end