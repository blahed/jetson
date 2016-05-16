require 'json'
require 'uri'

require 'json_color'
require 'rest-client'

module Jetson
  module DSL
    
    def set(option, value)
      instance_variable_set("@#{option}", value)
    end
    
    def session(host, &block)
      @host    = normalize_host(host)
      @verbose = false
      @cookies = {}
      @headers = {}
      
      self.instance_eval &block
    end
    
    def clear(resource = :all)
      case resource
      when :all
        @cookies = {}
        @headers = {}
      when :headers
        @headers = {}
      when :cookies
        @cookies = {}
      end
    end
    
    def request(method, url, *args)
      response = request!(method, url, *args)
      json     = parse_json(response.body) if response.headers[:content_type] =~ /json/
            
      print_request(response, json) if @verbose
      
      json
    rescue RestClient::InternalServerError => err
      puts "\033[1m#{method.to_s.upcase}\033[0m #{url} \033[31m#{err.response.code}\033[0m" 
    end
    
    def request!(method, url, params = {}, headers = {})
      options  = default_options
      url      = URI.join(@host, url).to_s
      
      options.merge!(headers)
      
      if method == :get
        options.merge!({params: params})
        res = RestClient.send(method, url, options)
      else
        res = RestClient.send(method, url, params.to_json, options)
      end
      
      @cookies.merge!(res.cookies)
      
      res
    end
    
    [:get, :post, :put, :patch, :delete].each do |name|
      define_method(name) { |url, *args| request(name, url, *args) }
      define_method("#{name}!".to_sym) { |url, *args| request!(name, url,*args) }
      alias_method name.upcase, name
      alias_method "#{name.upcase}!".to_sym, "#{name}!".to_sym
    end
    
    private
    
    def normalize_host(host)
      host =~ /\Ahttp/ ? host : "http://#{host}"
    end
    
    def parse_json(body)
      JSON.parse(body)
    rescue JSON::ParserError => err
      puts "\033[31mUnable to parse JSON\033[0m"
      puts err.backtrace
      nil
    end
    
    def default_options
      options           = { content_type: :json, accept: :json }.merge(@headers)
      options[:cookies] = @cookies unless @cookies.nil?
      
      options
    end
    
    def print_request(response, json)
      request = response.request
      url     = request.url.sub(@host, '')
      
      puts "\033[1m#{request.method.to_s.upcase}\033[0m #{url} \033[32m#{response.code}\033[0m"
      puts "\033[4mResponse\033[0m"
      if json
        puts JsonColor.colorize(JSON.pretty_generate(body))
      else
        puts response.body[0..100] + '...'
      end
    end
  end
end
