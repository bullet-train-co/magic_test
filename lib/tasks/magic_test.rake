namespace :magic_test do
  desc "Install Magic Test"
  task :install do
    system "rails g magic_test:install"
  end
end
