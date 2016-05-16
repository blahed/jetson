module Jetson
  class Commands
    extend Jetson::DSL
    
    def self.command(name, description = nil, &block)
      @commands     ||= {}
      @descriptions ||= {}
      @descriptions[name] = description
      @commands[name]     = block
    end
    
    command :get, 'Perform a GET request' do |url, params|
      params = eval(params) unless params.nil?
      
      request(:get, url, params)
    end
    
    command :post, 'Perform a POST request' do |url, params|
      params = eval(params) unless params.nil?
      
      request(:post, url, params)
    end
    
    command :put, 'Perform a PUT request' do |url, params|
      params = eval(params) unless params.nil?
      
      request(:put, url, params)
    end
    
    command :patch, 'Perform a PATCH request' do |url, params|
      params = eval(params) unless params.nil?
      
      request(:patch, url, params)
    end
    
    command :delete, 'Perform a DELETE request' do |url, params|
      params = eval(params) unless params.nil?
      
      request(:delete, url, params)
    end
      
    command :help, 'Show this list' do
      puts @descriptions.map { |name, desc| "#{name} - #{desc}" }.join("\n")
    end
    
    def self.run(command, url, params)
      @commands[command].call(url, params)
    end
    
  end
end
