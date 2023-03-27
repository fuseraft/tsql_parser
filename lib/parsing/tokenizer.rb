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
#   parsing/tokenizer.rb
# object:
#   TSqlParser::Parsing::Tokenizer

module TSqlParser::Parsing
  require_relative "parser"

  class Tokenizer
    def self.tokenize(tsql_string)
      tokens = basic_tokenize(
        tsql_string,
        ["(", ",", ")", "=", "+", "-", "%", "/", "*", "<", "!", ">", "'", "[", "]", ";"],
        [" ", "\n", "\t"]
      )
      tokens.map do |t|
        categorize(t)
      end
    end

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
      data[:string_mark] = true if Parser.is_string_mark? s
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

    def self.basic_tokenize(tsql_string, char_delimiters, skip_delimiters)
      specific_tokens = []
      delimiters = ([] << char_delimiters << skip_delimiters).flatten
      builder = ""
      tsql_chars = tsql_string.split("")
      multiline_comment = false
      comment = false
      string = false
      string_count = 0
      skip_count = 0
      tsql_chars.each_with_index do |c, i|
        if skip_count > 0
          skip_count -= 1
          next
        end

        next_c = tsql_chars[i + 1] unless i + 1 > tsql_chars.size

        if Parser.is_multiline_comment_start?(c, next_c)
          multiline_comment = true
          specific_tokens << builder unless builder.empty?
          builder = c
          next
        end

        if Parser.is_multiline_comment_end?(c, next_c)
          skip_count = 1
          multiline_comment = false
          builder << c << next_c
          specific_tokens << builder unless builder.empty?
          builder = ""
          next
        end

        if Parser.is_comment_start?(c, next_c)
          comment = true
          skip_count = 1
          specific_tokens << builder unless builder.empty?
          builder = "--"
          next
        end

        if c == "'" and not multiline_comment and not comment
          if not string
            string = true
            specific_tokens << builder unless builder.empty?
            builder = c
            next
          else
            string = false
            builder << c
            specific_tokens << builder unless builder.empty?
            builder = ""
            next
          end
        end

        if Parser.is_two_char_op?(c, next_c)
          skip_count = 1
          specific_tokens << builder unless builder.empty?
          specific_tokens << "#{c}#{next_c}"
          builder = ""
          next
        end

        if comment and c != "\n"
          builder << c
          next
        elsif comment and c == "\n"
          specific_tokens << builder unless builder.empty?
          builder = ""
          comment = false
          next
        end

        if delimiters.include? c and !multiline_comment and !string
          specific_tokens << builder unless builder.empty?
          specific_tokens << c unless skip_delimiters.include? c
          builder = ""
          next
        end

        builder << c
      end
      specific_tokens << builder unless builder.empty?
      specific_tokens
    end
  end
end
