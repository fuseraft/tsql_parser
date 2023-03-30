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
#   parsing/model/flat_sql_container.rb
# object:
#   TSqlParser::Parsing::FlatSqlContainer

module TSqlParser::Parsing
  class FlatSqlContainer
    def initialize(token = nil)
      @token = token
      @siblings = []

      unless token.nil?
        if token.has_nodes?
          token.get_nodes.each do |n|
            if n.get_token[:comment]
              comment_token = n.get_token
              comment_token[:value] = "#{comment_token[:value]}\n"
              n.set_token comment_token
            end
            @siblings << n
          end
        end
      end
    end

    def self.flatten_containers(containers)
      flat_containers = []
      containers.each do |c|
        flat_containers << FlatSqlContainer.new(c)
      end
      flat_containers
    end

    def set_token(token)
      @token = token
    end

    def add_sibling(token)
      @siblings << token
    end

    def has_siblings?
      @siblings.size > 0
    end

    def get_siblings
      @siblings
    end

    def get_token
      @token.get_token
    end

    def to_s
      @token.get_token[:value] unless @token.nil?
    end
  end
end
