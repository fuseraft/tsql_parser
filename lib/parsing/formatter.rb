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
  require_relative "iterator"
  require_relative "parser"
  require_relative "text_formatter"
  require_relative "model/sql_container"
  require_relative "model/flat_sql_container"

  class Formatter
    def self.format(tokens, tab_count = 0, tab = "    ")
      containers = self.as_containers(tokens)
      lines = self.combine_containers(containers)
      lines = self.cleanup_whitespace(lines)
      lines = self.insert_indentation(lines, tab_count, tab)
      lines = self.insert_newlines(lines)
      text = lines.join("\n")
      text = TextFormatter.format_inserts(text, tab)
      text = TextFormatter.format_updates(text, tab)
      text = TextFormatter.format_joins(text, tab)
      text = TextFormatter.format_wheres(text, tab)
      text = TextFormatter.format_selects(text, tab)
      text = TextFormatter.format_sets(text, tab)
      text
      puts text
    end

    private

    def self.insert_newlines(lines)
      new_lines = []
      lines.each do |line|
        first = line.strip.split(" ").first
        if first.nil?
          new_lines << ""
          next
        end
        if Parser.is_newline_required? first or first.start_with? "/*"
          new_lines << ""
        end
        new_lines << line
      end
      new_lines
    end

    def self.insert_indentation(lines, tab_count = 0, tab = "    ")
      indented_lines = []
      work_lines = []
      lines.each do |line|
        work_lines << line.split("\n")
      end
      sub_one = false
      work_lines = work_lines.flatten
      last = ""
      in_if_exists = false
      work_lines.each_with_index do |line, index|
        first = line.strip.split(" ").first
        next_line = work_lines[index + 1] unless index + 1 > work_lines.size
        next_line_first = next_line.strip.split(" ").first unless next_line.nil?

        if %w[CASE BEGIN SELECT].include? first or line.strip.start_with? "CREATE PROCEDURE"
          indented_lines << "#{tab * tab_count}#{line}"
          tab_count += 1
        elsif %w[FROM END GO].include? first and not %w[DELETE UPDATE INSERT].include? last
          tab_count -= 1 if tab_count > 0
          indented_lines << "#{tab * tab_count}#{line}"
        else
          indented_lines << "#{tab * tab_count}#{line}"
        end

        if sub_one
          sub_one = false
          tab_count -= 1 if tab_count > 0
        end
        last = first
      end
      indented_lines
    end

    def self.cleanup_whitespace(combined)
      lines = []
      combined.each do |c|
        lines << self.safe_ws_cleanup(c)
      end
      lines
    end

    def self.combine_containers(containers)
      lines = []
      containers.each do |c|
        ct = c.get_token

        builder = []
        builder << ct[:value]

        if c.has_siblings?
          c.get_siblings.each do |sibling|
            st = sibling.get_token

            if st[:comment]
              builder << "\n#{st[:value]}"
              next
            end

            builder << st[:value]
          end
        end

        lines << builder.join(" ")
      end

      lines
    end

    def self.as_containers(tokens)
      containers = []
      container = nil
      tokens.each do |t|
        if Parser.is_new_node_keyword? t[:value]
          containers << container unless container.nil?
          container = SqlContainer.new(t)
        else
          container.add t unless container.nil?
        end
      end
      containers << container unless container.nil?
      FlatSqlContainer.flatten_containers(containers)
    end

    def self.safe_ws_cleanup(line)
      parts = []
      builder = ""
      in_string = false
      line.split("").each do |c|
        # if we run into a single-quote
        # flip the in_string flag
        if c == "'"
          if not in_string
            in_string = true
            parts << builder unless builder.empty?
            builder = ""
            builder << c
          else
            in_string = false
            builder << c
            parts << builder
            builder = ""
          end
        else
          builder << c
        end
      end
      parts << builder unless builder.empty?
      parts.map do |p|
        if p.start_with? "'" and p.end_with? "'"
          p
        else
          self.fix_whitespace(p)
        end
      end.join
    end

    def self.fix_whitespace(line)
      line.gsub(" , ", ", ")
      #.gsub(' (', '(')
          .gsub(" )", ")")
          .gsub("( ", "(")
          .gsub("AS(", "AS (")
          .gsub("IN(", "IN (")
          .gsub(",(", ", (")
          .gsub("[ ", "[")
          .gsub(" ]", "]")
          .gsub("] .", "].")
          .gsub(". [", ".[")
          .gsub(" ;", ";")
    end
  end
end
