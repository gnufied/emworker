namespace :git do
  desc "Check in Code"
  task :push do
    sh("git push origin master")
  end
end
