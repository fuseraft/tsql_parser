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
#   parsing/formatters/update_formatter.rb
# object:
#   TSqlParser::Parsing::Formatters::UpdateFormatter

module TSqlParser::Parsing::Formatters
  require_relative "base_formatter"

  class UpdateFormatter < BaseFormatter
    def self.format(text, tab = "    ")
      formatted = []
      lines = text.split("\n")
      lines.each do |line|
        first = line.strip.split(" ").first
        if first != "UPDATE"
          formatted << line
          next
        end

        tab_count = self.get_tab_count(line, tab)
        update = line.strip[first.size + 1..]
        new_update = self.format_update(update, tab_count, tab)
        if new_update.nil?
          formatted << line
          next
        end
        formatted << line.sub(update, new_update)
      end
      formatted.join("\n")
    end

    private

    def self.format_update(s, tab_count = 0, tab = "    ")
      return s if s.nil?
      "\n#{tab * (tab_count + 1)}#{s}"
    end
  end
end
