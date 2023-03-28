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
#   parsing/formatter.rb
# object:
#   TSqlParser::Parsing::Formatter

module TSqlParser::Parsing
  require_relative 'strategy/set_formatter'
  require_relative 'strategy/join_formatter'
  require_relative 'strategy/insert_formatter'
  require_relative 'strategy/select_formatter'
  require_relative 'strategy/update_formatter'
  require_relative 'strategy/where_formatter'

  class TextFormatter
    def self.format_sets(text, tab = "    ")
      Formatters::SetFormatter.format(text, tab)
    end

    def self.format_joins(text, tab = "    ")
      Formatters::JoinFormatter.format(text, tab)
    end

    def self.format_updates(text, tab = "    ")
      Formatters::UpdateFormatter.format(text, tab)
    end

    def self.format_inserts(text, tab = "    ")
      Formatters::InsertFormatter.format(text, tab)
    end

    def self.format_selects(text, tab = "    ")
      Formatters::SelectFormatter.format(text, tab)
    end

    def self.format_wheres(text, tab = "   ")
      Formatters::WhereFormatter.format(text, tab)
    end
  end
end
