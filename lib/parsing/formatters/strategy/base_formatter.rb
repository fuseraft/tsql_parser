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
#   parsing/formatters/base_formatter.rb
# object:
#   TSqlParser::Parsing::Formatters::SetFormatter

module TSqlParser::Parsing::Formatters
  class BaseFormatter
    def self.get_tab_count(line, tab = "    ")
      tab_count = 0
      while line.start_with? tab
        tab_count += 1
        line = line.sub(tab, "")
      end
      tab_count
    end
  end
end
