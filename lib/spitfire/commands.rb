module Spitfire
  class Commands
    extend Spitfire::DSL
    
    command :get, 'Perform a GET request' do |args|
      RestClient.get(*args)
    end
    
    command :post, 'Perform a POST request' do |args|
      RestClient.post(*args)
    end
    
    command :put, 'Perform a PUT request' do |args|
      RestClient.put(*args)
    end
    
    command :patch, 'Perform a PATCH request' do |args|
      RestClient.patch(*args)
    end
    
    command :delete, 'Perform a DELETE request' do |args|
      RestClient.delete(*args)
    end
      
    command :help, 'Show this list' do
      puts @descriptions.map { |name, desc| "#{name} - #{desc}" }.join("\n")
    end
    
    def self.run(command, *args)
      @commands[command].call(args)
    end
    
  end
end