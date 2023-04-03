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
#   parsing/formatters/format_factory.rb
# object:
#   TSqlParser::Parsing::FormatFactory

module TSqlParser::Parsing
    require_relative "strategy/__formatters"
    class FormatFactory
        def self.get(type)
            case type
            when CTE then Formatters::CommonTableExpressionFormatter.new
            when INSERT then Formatters::InsertFormatter.new
            when JOIN then Formatters::JoinFormatter.new
            when SELECT then Formatters::SelectFormatter.new
            when SET then Formatters::SetFormatter.new
            when UPDATE then Formatters::UpdateFormatter.new
            when WHERE then Formatters::WhereFormatter.new
            end
        end
    end
end
