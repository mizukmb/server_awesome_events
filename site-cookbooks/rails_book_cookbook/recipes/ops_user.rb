# Cookbook Name:: rails_book_cookbook
# Recipe:: ops_user

user 'ops' do
  shell "/bin/bash"
  supports :manage_home => true
  home "/home/ops"
end
