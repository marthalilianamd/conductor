require_dependency "conductor/application_controller"
require 'pty'

module Conductor
  class TestsController < ApplicationController
  	def show
  		@tests  = File.read("tmp/test.log") 
  	end

  	def run_all
      run_test("rake test")
      redirect_to test_path
  	end
    
    def run_model
      spawn("rake test:models > tmp/test.log")
      redirect_to test_path
    end
    
    def run_controller
      spawn("rake test:controllers > tmp/test.log")
      redirect_to test_path
    end
    
    def run_integration
      spawn("rake test:integration > tmp/test.log")
      redirect_to test_path
    end
    def run_test(cmd)
      file = File.new("tmp/test.log", "w")   
      file.puts " "  
      file.close 
      begin
      PTY.spawn( cmd ) do |stdin, stdout, pid|
      begin
        stdin.each { |line| print line 
          open('tmp/test.log', 'a') { |f| f.puts line}
        }
          rescue Errno::EIO
          puts "Errno:EIO error, but this probably just means " +
            "that the process has finished giving output"
        end
      end
      rescue PTY::ChildExited
      puts "The child process exited!"
      end
    end
  end
end
