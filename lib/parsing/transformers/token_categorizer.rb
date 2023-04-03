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
#   parsing/transformers/token_categorizer.rb
# object:
#   TSqlParser::Parsing::TokenCategorizer

module TSqlParser::Parsing
  require_relative "../parser"

  class TokenCategorizer
    def self.categorize(s)
      data = {}
      data[:value] = s
      data[:keyword] = true if Parser.is_keyword? s
      data[:operator] = true if Parser.is_operator? s
      data[:function] = true if Parser.is_function? s
      data[:type] = true if Parser.is_type? s
      data[:comment] = true if Parser.is_comment? s
      data[:numeric] = true if Parser.is_numeric? s
      data[:special_variable] = true if Parser.is_special_variable? s
      data[:variable] = true if Parser.is_variable? s
      data[:temporary_table] = true if Parser.is_temp_table? s
      data[:label] = true if Parser.is_label? s
      data[:parenthesis] = true if Parser.is_parenthesis? s
      data[:open_parenthesis] = true if Parser.is_open_parenthesis? s
      data[:close_parenthesis] = true if Parser.is_close_parenthesis? s
      data[:bracket] = true if Parser.is_bracket? s
      data[:open_bracket] = true if Parser.is_open_bracket? s
      data[:close_bracket] = true if Parser.is_close_bracket? s
      data[:string] = true if Parser.is_string? s
      data[:comma] = true if Parser.is_comma? s
      data[:join] = true if Parser.is_join? s
      data[:join_type] = true if Parser.is_join_type? s
      data[:begin] = true if Parser.is_begin? s
      data[:end] = true if Parser.is_end? s
      data[:terminator] = true if Parser.is_terminator? s
      data[:value] = data[:value].upcase if data[:keyword] or data[:function] or data[:type]
      data[:needs_newline] = true if data[:keyword] and Parser.is_newline_required? s
      data
    end
  end
end
