class HelloWorldJob < ApplicationJob
  queue_as :default 
  

  before_perform :print_before_perform_message
  after_perform :print_after_perform_message

  def print_before_perform_message
    puts "Printing from inside before_perform callback"
  end

  def print_after_perform_message
    puts "Printing from inside after_perform callback"
  end

  def perform #(*args)
    # Do something later
    puts 'Hello World!'
  end
end
