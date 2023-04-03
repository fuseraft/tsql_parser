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
#   parsing/formatters/from_formatter.rb
# object:
#   TSqlParser::Parsing::Formatters::FromFormatter

module TSqlParser::Parsing::Formatters
    require_relative "base_formatter"

    class FromFormatter < BaseFormatter
      def format(text, tab = Defaults.get_default_tab)
        formatted = []
        lines = text.split("\n")
        lines.each_with_index do |line, index|
            if line.strip.start_with? "--" or line.strip.start_with? "/*" or line.strip.end_with? "'"
                formatted << line
                next
            end

            if line.include? " FROM " and not line.include? " EXISTS ("
                tab_count = self.get_tab_count(line, tab)
                if line.count(" FROM ") == 1
                    from_parts = line.split(" FROM ")
                    formatted << "#{from_parts[0]}\n#{tab * tab_count}FROM #{from_parts[1]}"
                else
                    formatted << line[..line.index(" FROM ") - 1]
                    formatted << "#{tab * tab_count}#{line[line.index(" FROM ") + 1..]}"
                end
            else
                formatted << line
            end
        end
        formatted.join("\n")
      end
    end
end