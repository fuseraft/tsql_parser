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
#   parsing/formatters/where_formatter.rb
# object:
#   TSqlParser::Parsing::Formatters::WhereFormatter

module TSqlParser::Parsing::Formatters
  require_relative "base_formatter"

  class WhereFormatter < BaseFormatter
    def self.format(text, tab = "   ")
      formatted = []
      text.split("\n").each do |line|
        first = line.strip.split(" ").first
        if first != "WHERE"
          formatted << line
          next
        end

        tab_count = self.get_tab_count(line, tab)
        predicate = line.strip[first.size + 1..]
        new_predicate = self.format_predicate(predicate, tab_count, tab)
        if new_predicate.nil?
          formatted << line
          next
        end
        formatted << line.sub(predicate, new_predicate)
      end

      formatted.join("\n")
    end

    private

    def self.format_predicate(s, tab_count = 0, tab = "    ")
      return s if s.nil?
      indented = []
      formatted = []
      builder = []

      tokens = s.split(" ")
      tokens.each do |t|
        if %w[AND OR].include? t
          formatted << builder.join(" ") unless builder.empty?
          builder = [t]
        else
          builder << t
        end
      end
      formatted << builder.join(" ")

      level = tab_count
      formatted.each_with_index do |f, i|
        indented << "#{tab * (level + 1)}#{f}"
        level -= f.count(")")
        level += f.count("(")
      end

      "\n#{indented.join("\n")}"
    end
  end
end
