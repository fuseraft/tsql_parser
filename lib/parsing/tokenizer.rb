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
  require_relative "transformers/token_categorizer"

  class Tokenizer
    @@default_char_delimiters = ["(", ",", ")", "=", "+", "-", "%", "/", "*", "<", "!", ">", "'", "[", "]", ";"]
    @@default_skip_delimiters = [" ", "\n", "\t"]

    def self.set_default_char_delimiters(char_delimiters = [])
      @@default_char_delimiters = char_delimiters
    end

    def self.set_default_skip_delimiters(skip_delimiters = [])
      @@default_skip_delimiters = skip_delimiters
    end

    def self.tokenize(tsql_string)
      Tokenizer.new.basic_tokenize(tsql_string).map { |t| TokenCategorizer.categorize(t) }
    end

    def basic_tokenize(tsql_string)
      self.reset
      tsql_chars = tsql_string.split("")

      tsql_chars.each_with_index do |c, i|
        if @skip_count > 0
          @skip_count -= 1
          next
        end

        # get last and next char
        @c = c
        @last_c = tsql_chars[i - 1] unless i - 1 < 0
        @next_c = tsql_chars[i + 1] unless i + 1 > tsql_chars.size

        # if we aren't in a string.
        unless @string
          next if self.handle_multicomment_start
          next if self.handle_multicomment_end
          next if self.handle_singlecomment_start
          next if self.build_comment
        end

        unless @multiline_comment or @comment
          next if self.handle_string_char
          next if self.handle_two_char_op
          next if self.handle_delimiter
        end

        self.build
      end

      self.flush_builder
      @tokens
    end

    private

    def handle_multicomment_start
      if Parser.is_multiline_comment_start?(@c, @next_c)
        @multiline_comment = true
        self.flush_builder(c)
        return true
      end
    end

    def handle_multicomment_end
      if Parser.is_multiline_comment_end?(@c, @next_c)
        @skip_count = 1
        @multiline_comment = false
        self.build
        self.build(@next_c)
        self.flush_builder("")
        return true
      end
    end

    def handle_singlecomment_start
      if Parser.is_comment_start?(@c, @next_c) and not @comment
        @comment = true
        @skip_count = 1
        self.flush_builder("--")
        return true
      end
    end

    def handle_singlecomment_end
      if @c == "\n"
        self.flush_builder("")
        @comment = false
        return true
      end
    end

    def handle_string_char
      if @c == "'"
        @string_count += 1
        return true if self.handle_string_start
        @string_count += 1 if @next_c == "'"
        return true if self.handle_string_end
      end
    end

    def handle_string_start
      if not @string
        @string = true
        self.flush_builder(@c)
        return true
      end
    end

    def handle_string_end
      if @string_count % 2 == 0
        @string = false
        @string_count = 0
        self.build
        self.flush_builder("")
        return true
      end
    end

    def handle_two_char_op
      if Parser.is_two_char_op?(@c, @next_c)
        @skip_count = 1
        self.flush_builder("")
        @tokens << "#{@c}#{@next_c}"
        return true
      end
    end

    def handle_delimiter
      if @delimiters.include? @c and !@multiline_comment and !@comment and !@string
        self.flush_builder("")
        @tokens << @c unless @skip_delimiters.include? @c
        return true
      end
    end

    def build(value = nil)
      @builder << @c if value.nil?
      @builder << value unless value.nil?
    end

    def build_comment
      if @comment
        return true if self.handle_singlecomment_end

        self.build
        return true
      end
    end

    def flush_builder(value = nil)
      @tokens << @builder unless @builder.empty?
      @builder = value
    end

    def initialize
      self.reset
    end

    def reset
      @tokens = []
      @multiline_comment = false
      @comment = false
      @string = false
      @string_count = 0
      @skip_count = 0
      @char_delimiters = @@default_char_delimiters
      @skip_delimiters = @@default_skip_delimiters
      @delimiters = ([] << @char_delimiters << @skip_delimiters).flatten.uniq
      @builder = ""
    end
  end
end
