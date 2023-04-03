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
#   parsing/formatters/strategy/__formatters.rb

module TSqlParser::Parsing
  require_relative "cte_formatter"
  require_relative "set_formatter"
  require_relative "join_formatter"
  require_relative "insert_formatter"
  require_relative "select_formatter"
  require_relative "update_formatter"
  require_relative "where_formatter"
  require_relative "from_formatter"

  CTE = 0
  INSERT = 1
  JOIN = 2
  SELECT = 3
  SET = 4
  UPDATE = 5
  WHERE = 6
  FROM = 7
end
