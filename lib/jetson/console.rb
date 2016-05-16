require 'irb'
require 'irb/completion'
require 'irb/ext/save-history'

module Jetson
  class Console
    class Context
      include Jetson::DSL
      
      def initialize(host, *args)
        @host    = normalize_host(host)
        @verbose = true
        @cookies = {}
        @headers = {}
      end
      
      def help
        
      end
      
      def to_s
        @host.sub(/\Ahttps?:\/\//, '')
      end
    end
    
    def self.start
      new.start
    end
    
    def start
      host, *args = ARGV
      
      ARGV.clear
      IRB.setup nil

      IRB.conf[:PROMPT]   = {}
      IRB.conf[:IRB_NAME] = 'jetson'
      IRB.conf[:PROMPT][:JETSON] = {
        :PROMPT_I => "\033[1m%m>\033[0m ",
        :PROMPT_N => nil,
        :PROMPT_S => nil,
        :PROMPT_C => nil,
        :RETURN => "%s\n"
      }
      IRB.conf[:PROMPT_MODE]  = :JETSON
      IRB.conf[:ECHO]         = false
      IRB.conf[:RC]           = false
      IRB.conf[:READLINE]     = true
      IRB.conf[:SAVE_HISTORY] = 1000
      IRB.conf[:HISTORY_FILE] = '~/.jetson'
      
      begin
        dev_null = File.open('/dev/null', "w")
        $stdout = dev_null
        irb = IRB::Irb.new(IRB::WorkSpace.new(Context.new(host, *args)))
      ensure
        dev_null.close()
        $stdout = STDOUT
      end

      
      IRB.conf[:MAIN_CONTEXT] = irb.context

      trap(:SIGINT) do
        IRB.irb.signal_handle
      end

      begin
        catch(:IRB_EXIT) do
          irb.eval_input
        end
      ensure
        IRB.irb_at_exit
      end
    end
    
    private
    
    def normalize_host
      
    end
  end
end
