require 'json'

require 'json_color'
require 'rest-client'

module Spitfire
  module DSL
    
    def set(option, value)
      instance_variable_set("@#{option}", value)
    end
    
    def session(&block)
      @cookies = {}
      @headers = {}
      
      self.instance_eval &block
    end
    
    def request(method, url, params = nil)
      res      = RestClient.send(method, url, options)
      json     = JSON.parse(res.body)
      
      @cookies.merge!(res.cookies)
      
      json
    end
    
    def request!(method, url, params = nil)
      res      = RestClient.send(method, url, options)
      json     = JSON.parse(res.body)
      
      @cookies.merge!(res.cookies)
      
      puts "\033[1m#{method.to_s.upcase}\033[0m #{url} \033[32m#{res.code}\033[0m"
      pretty_print_headers(res.headers) if @verbose
      pretty_print_body(json)
      
      res.body
    end
    
    [:get, :post, :put, :patch, :delete].each do |name|
      define_method(name) { |url, params = nil| request(name, url, params) }
      define_method("#{name}!".to_sym) { |url, params = nil| request!(name, url, params) }
    end
    
    private
    
    def options
      options           = { content_type: :json, accept: :json }.merge(@headers)
      options[:cookies] = @cookies unless @cookies.nil?
      
      puts options.inspect

      options
    end
    
    def pretty_print_headers(headers)
      puts "\033[4mHeaders\033[0m"
      headers.each do |name, value|
        puts "\033[1m#{name.to_s.capitalize.gsub(/_(\w)/i) {|_| '-' + $1.upcase }}:\033[0m #{value}"
      end
    end
    
    def pretty_print_body(body)
      puts "\033[4mResponse\033[0m"
      puts JsonColor.colorize(JSON.pretty_generate(body))
    end
  end
end
