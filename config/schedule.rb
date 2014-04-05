# Use this file to easily define all of your cron jobs.
# Learn more: http://github.com/javan/whenever

every :month, :at => '2pm' do
  rake 'directory:import'
  rake 'directory:update_students'
  rake 'directory:populate'
end