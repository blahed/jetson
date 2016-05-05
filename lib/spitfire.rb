require 'rest-client'

require 'spitfire/dsl'
require 'spitfire/commands'
require 'spitfire/version'

module Spitfire
  def self.prompt
    print "[#{@host}]: "
  end
  
  def self.run(host)
    @host = host
    
    loop do
      prompt
      
      input = STDIN.gets.chomp
      command, *params = input.split(/\s/)

      case command
      when /\Ahelp\z/i
        Spitfire::Commands.run(:help)
      when /\Aget\z/i
        Spitfire::Commands.run(:get, "#{@host}/#{params.first}")
      else 
        puts 'Invalid command'
      end
    end
  end
end
