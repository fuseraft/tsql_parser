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
        next if first.nil?

        if first.start_with? "--" or first.start_with? "/*" or line.strip.end_with? "'"
          new_text << line
          next
        end

        tab_count = self.get_tab_count(line, tab)

        if line.include? " JOIN "
          new_text << self.format_joins(line, tab, tab_count)
        else
          new_text << line
        end
      end

      new_text.join("\n")
    end

    private

    def format_joins(line, tab, tab_count)
      formatted = []
      builder = []
      tokens = line.strip.split(" ")
      skip_count = 0
      tokens.each_with_index do |t, i|
        if skip_count > 0
          skip_count -= 1
          next
        end

        last_one = tokens[i - 1] if i - 1 > 0
        future_one = tokens[i + 1] if i + 1 < tokens.size
        future_two = tokens[i + 2] if i + 2 < tokens.size
        future_three = tokens[i + 3] if i + 3 < tokens.size

        next_two = "#{future_one} #{future_two}"
        next_three = "#{future_one} #{future_two} #{future_three}"

        if ["INNER JOIN", "LEFT JOIN", "RIGHT JOIN", "FULL JOIN", "CROSS JOIN"].include? next_two
          builder << t
          formatted << "#{tab * tab_count}#{builder.join(" ")}" unless builder.empty?
          builder = [next_two]
          skip_count = 2
        elsif ["LEFT OUTER JOIN", "RIGHT OUTER JOIN", "FULL OUTER JOIN"].include? next_three
          builder << t
          formatted << "#{tab * tab_count}#{builder.join(" ")}" unless builder.empty?
          builder = [next_three]
          skip_count = 3
        elsif t == "JOIN" and (not last_one.nil? and not %w[INNER LEFT RIGHT FULL CROSS OUTER].include? last_one)
          formatted << "#{tab * tab_count}#{builder.join(" ")}" unless builder.empty?
          builder = [t]
        else
          builder << t
        end
      end
      
      formatted << "#{tab * tab_count}#{builder.join(" ")}" unless builder.empty?
      builder = []

      formatted.join("\n")
    end
  end
end
