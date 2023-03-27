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
#   parsing/parser.rb
# object:
#   TSqlParser::Parsing::Parser

module TSqlParser::Parsing
  require_relative "keyword"

  class Parser
    def self.is_multiline_comment_start?(c, next_c)
      c == "/" and next_c == "*"
    end

    def self.is_multiline_comment_end?(c, next_c)
      c == "*" and next_c == "/"
    end

    def self.is_comment_start?(c, next_c)
      c == "-" and next_c == "-"
    end

    def self.is_operator?(s)
      ["<>", "!=", "<=", ">=", "!<", "!>", "+=", "-=", "*=", "/=", "%=", "==", "=", "+", "-", "%", "/", "*", "<", ">"].include? s
    end

    def self.is_one_char_op?(c)
      ["=", "+", "-", "%", "/", "*", "<", ">"].include? c
    end

    def self.is_two_char_op?(c, next_c)
      ["<>", "!=", "<=", ">=", "==", "!<", "!>", "+=", "-=", "*=", "/=", "%="].include? "#{c}#{next_c}"
    end

    def self.is_numeric?(s)
      s.match? /\A-?+(?=.??\d)\d*\.?\d*\z/
    end

    def self.is_variable?(s)
      s.start_with? "@"
    end

    def self.is_special_variable?(s)
      s.start_with? "@@"
    end

    def self.is_temp_table?(s)
      s.start_with? "#"
    end

    def self.is_label?(s)
      s.end_with? ":"
    end

    def self.is_parenthesis?(s)
      ["(", ")"].include? s
    end

    def self.is_open_parenthesis?(s)
      s == "("
    end

    def self.is_close_parenthesis?(s)
      s == ")"
    end

    def self.is_bracket?(s)
      ["[", "]"].include? s
    end

    def self.is_open_bracket?(s)
      s == "["
    end

    def self.is_close_bracket?(s)
      s == "]"
    end

    def self.is_string_mark?(s)
      s == "'"
    end

    def self.is_comma?(s)
      s == ","
    end

    def self.is_comment?(s)
      (s.start_with? "/*" and s.end_with? "*/") or s.start_with? "--"
    end

    def self.is_keyword?(s)
      Keyword.get_keywords.include? s.upcase
    end

    def self.is_begin?(s)
      Keyword.get_begin_keyword == s.upcase
    end

    def self.is_end?(s)
      Keyword.get_end_keyword == s.upcase
    end

    def self.is_join?(s)
      Keyword.get_join_keywords.include? s.upcase
    end

    def self.is_join_type?(s)
      Keyword.get_join_type_keywords.include? s.upcase
    end

    def self.is_function?(s)
      Keyword.get_functions.include? s.upcase
    end

    def self.is_type?(s)
      Keyword.get_types.include? s.upcase
    end

    def self.is_special_variable?(s)
      Keyword.get_special_variables.include? s.upcase
    end

    def self.is_newline_required?(s)
      Keyword.get_newline_keywords.include? s.upcase
    end

    def self.is_new_node_keyword?(s)
      Keyword.get_new_node_keywords.include? s.upcase
    end

    def self.is_terminator?(s)
      s == ";"
    end
  end
end
