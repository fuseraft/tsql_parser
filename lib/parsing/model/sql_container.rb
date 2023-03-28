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
#   parsing/model/sql_container.rb
# object:
#   TSqlParser::Parsing::SqlContainer

module TSqlParser::Parsing
  class SqlContainer
    def initialize(token = nil)
      @token = token
      @nodes = []
    end

    def self.combine(first, second)
      token = {}
      token[:value] = "#{first[:value]} #{second[:value]}"
      [first, second].each do |t|
        t.each do |k, v|
          token[k] = v unless token.has_key? k
        end
      end
      SqlContainer.new(token)
    end

    def set_token(token)
      @token = token
    end

    def add(token)
      @nodes << SqlContainer.new(token)
    end

    def has_nodes?
      @nodes.size > 0
    end

    def get_nodes
      @nodes
    end

    def get_token
      @token
    end

    def to_s
      @token[:value] unless @token.nil?
    end
  end
end
