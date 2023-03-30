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
    def self.transform(tokens)
      containers = self.as_containers(tokens)
      self.combine_containers(containers)
    end

    private

    def self.as_containers(tokens)
      containers = []
      container = nil
      skip_count = 0
      tokens.each_with_index do |t, index|
        if skip_count > 0
          skip_count -= 1
          next
        end

        next_token = tokens[index + 1]
        if Parser.is_new_node_keyword? t[:value]
          if not next_token.nil? and Parser.is_new_node_keyword? next_token[:value]
            if Parser.is_new_node_composite?(t[:value], next_token[:value])
              containers << container unless container.nil?
              container = SqlContainer.combine(t, next_token)
              skip_count = 1
              next
            end
          end
          containers << container unless container.nil?
          container = SqlContainer.new(t)
        elsif t[:value] == "WITH"
          if not next_token.nil? and not next_token[:keyword] and not next_token[:parenthesis]
            containers << container unless container.nil?
            container = SqlContainer.new(t)
          else
            container.add t unless container.nil?
          end
        elsif t[:label]
          containers << container unless container.nil?
          container = SqlContainer.new(t)
        else
          container.add t unless container.nil?
        end
      end
      containers << container unless container.nil?
      FlatSqlContainer.flatten_containers(containers)
    end

    def self.combine_containers(containers)
      lines = []
      containers.each do |c|
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
