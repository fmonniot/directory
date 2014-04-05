# spec/support/debug_helpers.rb
module Debug
  module TimeHelpers
    def wait(time=10)
      print "Enter sleep mode (#{time} seconds)"
      time.times do 
        sleep(1)
        print '.'
      end
      puts ' finished'
    end
  end
end