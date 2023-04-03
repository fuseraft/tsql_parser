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
  require_relative "__defaults"

  class BaseFormatter
    def get_tab_count(line, tab = Defaults.get_default_tab)
      tab_count = Defaults.get_default_tab_count
      while line.start_with? tab
        tab_count += 1
        line = line.sub(tab, "")
      end
      tab_count
    end

    # @abstract
    #
    # @param [String] text
    # @param [String] tab
    def format(text, tab = Defaults.get_default_tab)
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end
  end
end
