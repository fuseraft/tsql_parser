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
#   parsing/formatters/set_formatter.rb
# object:
#   TSqlParser::Parsing::Formatters::SetFormatter

module TSqlParser::Parsing::Formatters
  require_relative 'base_formatter'

  class SetFormatter < BaseFormatter
    def self.format(text, tab = "    ")
      formatted = []
      lines = text.split("\n")
      wait = false
      set_lines = []
      lines.each do |line|
        first = line.strip.split(" ").first
        if %w[FROM WHERE].include? first and wait
          wait = false
          tab_count = self.get_tab_count(line, tab)
          set_text = set_lines.join("\n")
          first = set_text.strip.split(" ").first
          set = set_text.strip[first.size + 1..]
          new_set = self.format_set(set, tab_count, tab)
          if new_set.nil?
            formatted << line
            next
          end
          formatted << "#{tab * tab_count}SET #{new_set}"
          formatted << line
          set_lines = []
          next
        end

        if first == "SET" and not line.strip.start_with? "SET @" and not %w[ON OFF].include? line.strip.split(" ").last
          wait = true
          set_lines << line
        elsif first != "SET" and line.include? " SET "
          parts = line.strip.split(" SET ")
          tab_count = self.get_tab_count(line, tab)
          formatted << "#{tab * tab_count}#{parts[0]}\n"
          parts[1..].each { |p| formatted << "#{tab * tab_count}SET #{p}" }
        elsif wait
          set_lines << line
        else
          formatted << line
        end
      end
      formatted.join("\n")
    end

    private

    def self.format_set(s, tab_count = 0, tab = "    ")
      return s if s.nil?
      parts = []
      builder = ""
      parenthesis = 0
      tokens = s.split("")
      comment = false
      skip_count = 0
      tokens.each_with_index do |c, i|
        if skip_count > 0
          skip_count -= 1
          next
        end

        if comment
          if c == "\n"
            comment = false
            parts << builder unless builder.empty?
            builder = ""
          else
            builder << c
          end
          next
        end

        parenthesis += 1 if c == "("
        parenthesis -= 1 if c == ")"
        next_c = tokens[i + 1] if tokens.size > i + 1
        if c == ","
          if parenthesis > 0
            builder << c
          else
            parts << builder unless builder.empty?
            builder = ""
          end
        elsif c == "\n"
          parts << builder unless builder.empty?
          builder = ""
        elsif c == "-"
          if next_c == "-"
            comment = true
            skip_count = 1
            parts << builder unless builder.empty?
            builder = "--"
          else
            builder << c
          end
        else
          builder << c
        end
      end
      parts << builder unless builder.empty?
      parts = parts.map { |p| p.strip }.select { |p| not p.empty? }
      "\n#{parts.map { |p| "#{tab * (tab_count + 1)}#{p.strip}" }.join(",\n")}"
    end
  end
end
