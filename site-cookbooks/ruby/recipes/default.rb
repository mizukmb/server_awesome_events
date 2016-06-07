#
# Cookbook Name:: ruby
# Recipe:: default

%w{libreadline-dev libyaml-dev libxslt-dev libssl-dev
   ncurses-dev libgdbm-dev libffi-dev tk-dev}.each do |pkg|
  package pkg do
    action :install
  end
end

git "/home/ops/.rbenv" do
  repository "git://github.com/sstephenson/rbenv.git"
  reference "master"
  action :sync
  user "ops"
  group "ops"
end

%w{/home/ops/.rbenv/plugins}.each do |dir|
  directory dir do
    action :create
    user "ops"
    group "ops"
  end
end

git "/home/ops/.rbenv/plugins/ruby-build" do
  repository "git://github.com/sstephenson/ruby-build.git"
  reference "master"
  action :sync
  user "ops"
  group "ops"
end

bash "insert_line_rbenvpath" do
  not_if 'grep ".rbenv" /home/ops/.bashrc'
  environment "HOME" => '/home/ops'
  code <<-EOS
    echo 'export PATH="/home/ops/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    chmod 777 ~/.bashrc
    source ~/.bashrc
  EOS
end

bash "install ruby" do
  not_if "ls /home/ops/.rbenv/versions/2.3.1"
  user "ops"
  group "ops"
  environment "HOME" => '/home/ops'
  code <<-EOS
    /home/ops/.rbenv/bin/rbenv install 2.3.1
    /home/ops/.rbenv/bin/rbenv rehash
    /home/ops/.rbenv/bin/rbenv global 
  EOS
end
