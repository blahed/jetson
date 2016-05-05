module Spitfire
  module DSL
    def command(name, description = nil, &block)
      @commands     ||= {}
      @descriptions ||= {}
      @descriptions[name] = description
      @commands[name]     = block
    end
  end
end