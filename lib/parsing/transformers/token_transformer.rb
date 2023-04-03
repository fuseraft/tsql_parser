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
#   parsing/model/token_transformer.rb
# object:
#   TSqlParser::Parsing::TokenTransformer

module TSqlParser::Parsing
  require_relative "../models/sql_container"
  require_relative "../models/flat_sql_container"

  class TokenTransformer
    def initialize(tokens = [])
      @containers = []
      @container = nil
      @skip_count = 0
      @cte = ""
      @parenthesis = 0
      @tokens = tokens
    end

    def self.transform(tokens)
      TokenTransformer.new(tokens).transform
    end

    def transform
      @tokens.each_with_index do |t, index|
        @parenthesis += 1 if t[:open_parenthesis]
        @parenthesis -= 1 if t[:close_parenthesis]

        next if self.handle_skip  

        @t = t
        @last_token = @tokens[index - 1] unless index - 1 < 0
        @next_token = @tokens[index + 1] unless index + 1 > @tokens.size

        next if self.handle_cte_end   

        if t[:string]
          self.add_to_container
        elsif Parser.is_new_node_keyword? t[:value]
          if not @next_token.nil? and Parser.is_new_node_keyword? @next_token[:value]
            if Parser.is_new_node_composite?(@t[:value], @next_token[:value])
              self.add_container
              @container = SqlContainer.combine(@t, @next_token)
              @skip_count = 1
              next
            end
          end
          self.add_container
          self.new_container
        elsif t[:value] == "WITH"
          if not @next_token.nil? and not @next_token[:keyword] and not @next_token[:parenthesis]
            self.add_container
            self.new_container
            @cte = @next_token[:value]
          else
            self.add_to_container
          end
        elsif @t[:label]
          self.add_container
          self.new_container
        else
          self.add_to_container
        end
      end
      self.add_container
      self.get_lines_from_containers
    end

    private

    def handle_skip
      if @skip_count > 0
        @skip_count -= 1
        return true
      end
    end

    def add_to_container
      @container.add @t unless @container.nil?
    end

    def add_container
      @containers << @container unless @container.nil?
    end

    def new_container
      @container = SqlContainer.new(@t)
    end

    def handle_cte_end
      if not @cte.empty? 
        if not @last_token.nil? and @last_token[:close_parenthesis] and @parenthesis == 0
          if @t[:keyword]
            self.add_container
            self.new_container
            @cte = ""
          else
            self.add_to_container
          end
        elsif not @last_token.nil? and not @last_token[:keyword] and @t[:value] == "AS"
          self.add_to_container
        elsif not @last_token.nil? and @last_token[:comma] and not @t[:keyword] and not @next_token.nil? and @next_token[:value] == "AS"
          self.add_container
          self.new_container
          @cte = @t[:value]
        else
          self.add_to_container
        end
        return true
      end
    end

    def get_lines_from_containers
      @containers = FlatSqlContainer.flatten_containers(@containers)
      
      lines = []
      @containers.each do |c|
        ct = c.get_token

        builder = []
        builder << ct[:value]

        if c.has_siblings?
          c.get_siblings.each do |sibling|
            st = sibling.get_token

            if st[:comment]
              builder << "\n#{st[:value]}"
              next
            end

            builder << st[:value]
          end
        end

        lines << builder.join(" ")
      end

      lines
    end
  end
end
