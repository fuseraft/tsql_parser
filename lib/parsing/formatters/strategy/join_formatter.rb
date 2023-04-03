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
#   parsing/formatters/join_formatter.rb
# object:
#   TSqlParser::Parsing::Formatters::JoinFormatter

module TSqlParser::Parsing::Formatters
  require_relative "base_formatter"

  class JoinFormatter < BaseFormatter
    def format(text, tab = Defaults.get_default_tab)
      text = text.gsub(/INNER\s+JOIN/, "INNER JOIN")
                 .gsub(/LEFT\s+JOIN/, "LEFT JOIN")
                 .gsub(/RIGHT\s+JOIN/, "RIGHT JOIN")
                 .gsub(/CROSS\s+JOIN/, "CROSS JOIN")
      lines = text.split("\n")
      new_text = []

      lines.each do |line|
        first = line.strip.split(" ").first
        if line.include? " WHERE " and first != "WHERE" and not first.start_with? "--" and not first.start_with? "/*" and not line.strip.end_with? "'"
          tab_count = self.get_tab_count(line, tab)
          where_parts = line.strip.split(" WHERE ")
          where_text = []
          where_text << "#{tab * tab_count}#{where_parts[0]}"
          where_text << "#{tab * tab_count}WHERE #{where_parts[1]}"
          new_text << where_text.join("\n")
        else
          new_text << line
        end
      end

      new_text.join("\n")
    end
  end
end
