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
#   tsql_parser.rb
# object:
#   TSqlParser

module TSqlParser
  # Formats a SQL string.
  #
  # @param sql [String] the SQL string to format.
  # @param tab_count [Integer] the number of tabs to start with.
  # @param tab [String] the tab string.
  # @return [String] the formatted SQL string.
  def self.format(sql, tab_count = 0, tab = "    ")
    require_relative "parsing/formatter"
    tokens = self.parse(sql)
    Parsing::Formatter.format(tokens, tab_count, tab)
  end

  # Parses SQL string into token hashes.
  #
  # @param sql [String] the SQL string to parse.
  # @return [Array] the token hashes.
  def self.parse(sql)
    require_relative "parsing/tokenizer"
    Parsing::Tokenizer.tokenize(sql)
  end
end
