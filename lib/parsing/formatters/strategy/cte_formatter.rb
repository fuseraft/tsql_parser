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
#   parsing/formatters/cte_formatter.rb
# object:
#   TSqlParser::Parsing::Formatters::CommonTableExpressionFormatter

module TSqlParser::Parsing::Formatters
    require_relative "base_formatter"

    class CommonTableExpressionFormatter < BaseFormatter
      def format(text, tab = Defaults.get_default_tab)
        formatted = []
        lines = text.split("\n")
        lines.each_with_index do |line, index|
          clean_line = line.strip
          tab_count = self.get_tab_count(line, tab)
          if clean_line.include? " AS (SELECT "
            if clean_line.start_with? "WITH" and clean_line.end_with? ")"
              cte_parts = clean_line.split(" AS (SELECT ")
              cte_name = cte_parts[0]
              cte_body = "AS (\n#{tab * (tab_count + 1)}SELECT #{cte_parts[1][..-2]}\n#{tab * tab_count})"
              formatted << "#{tab * tab_count}#{cte_name} #{cte_body}"
            elsif clean_line.end_with? ") ,"
              cte_parts = clean_line.split(" AS (SELECT ")
              cte_name = cte_parts[0]
              cte_body = "AS (\n#{tab * (tab_count + 1)}SELECT #{cte_parts[1].sub(") ,", "")}\n#{tab * tab_count}),"
              formatted << "#{tab * tab_count}#{cte_name} #{cte_body}"
            elsif clean_line.end_with? ")"
              cte_parts = clean_line.split(" AS (SELECT ")
              cte_name = cte_parts[0]
              cte_body = "AS (\n#{tab * (tab_count + 1)}SELECT #{cte_parts[1][..-2]}\n#{tab * tab_count})"
              formatted << "#{tab * tab_count}#{cte_name} #{cte_body}"
            end
          else
            formatted << line
          end
        end

        formatted.join("\n")
      end
    end
  end
  