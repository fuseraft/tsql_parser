#   __               .__
# _/  |_  ___________|  |           ___________ _______  ______ ___________
# \   __\/  ___/ ____/  |    ______ \____ \__  \\_  __ \/  ___// __ \_  __ \
#  |  |  \___ < <_|  |  |__ /_____/ |  |_> > __ \|  | \/\___ \\  ___/|  | \/
#  |__| /____  >__   |____/         |   __(____  /__|  /____  >\___  >__|
#            \/   |__|              |__|       \/           \/     \/
#
# A very light-weight and opinionated T-SQL parser and formatter.
#
# github.com/scstauf
#
# path:
#   parsing/iterator.rb
# object:
#   TSqlParser::Parsing::TokenIterator

module TSqlParser::Parsing
  class TokenIterator
    def initialize(tokens)
      @tokens = tokens
      @size = tokens.size
      @iter = -1
    end

    def has_next?
      @iter < @size - 1
    end

    def get!
      @tokens[@iter]
    end

    def peek!
      @tokens[@iter + 1]
    end

    def peek_ahead!(length)
      @tokens[@iter + length]
    end

    def peek_value!
      self.peek![:value]
    end

    def peek_ahead_value!(length)
      self.peek_ahead!(length)[:value]
    end

    def next!
      @iter += 1
      self.get!
    end
  end
end
