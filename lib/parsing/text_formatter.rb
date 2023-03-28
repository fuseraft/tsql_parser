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
  class TextFormatter
    def self.format_sets(text, tab = "    ")
      formatted = []
      lines = text.split("\n")
      lines.each do |line|
        first = line.strip.split(" ").first
        if first == "SET" and not line.strip.start_with? "SET @"
          tab_count = self.get_tab_count(line, tab)
          set = line.strip[first.size + 1..]
          new_set = self.format_set(set, tab_count, tab)
          if new_set.nil?
            formatted << line
            next
          end
          formatted << line.sub(set, new_set)
        elsif first != "SET" and line.include? " SET "
          parts = line.strip.split(" SET ")
          tab_count = self.get_tab_count(line, tab)
          formatted << "#{tab * tab_count}#{parts[0]}\n"
          parts[1..].each { |p| formatted << "#{tab * tab_count}SET #{p}" }
        else
          formatted << line
        end
      end
      formatted.join("\n")
    end

    def self.format_joins(text, tab = "    ")
      text = text.gsub(/INNER\s+JOIN/, "INNER JOIN")
                 .gsub(/LEFT\s+JOIN/, "LEFT JOIN")
      lines = text.split("\n")
      new_text = []

      lines.each do |line|
        first = line.strip.split(" ").first
        if line.include? " WHERE " and first != "WHERE" and not first.start_with? "--" and not first.start_with? "/*"
          tab_count = self.get_tab_count(line, tab)
          where_parts = line.strip.split(" WHERE ")
          where_text = []
          where_text << "#{tab * tab_count}#{where_parts[0]}"
          where_text << "#{tab * tab_count}WHERE #{where_parts[1]}"
          new_text << where_text.join("\n")
        else
          new_text << line
        end
      end

      new_text.join("\n")
    end

    def self.format_updates(text, tab = "    ")
      formatted = []
      lines = text.split("\n")
      lines.each do |line|
        first = line.strip.split(" ").first
        if first != "UPDATE"
          formatted << line
          next
        end

        tab_count = self.get_tab_count(line, tab)
        update = line.strip[first.size + 1..]
        new_update = self.format_update(update, tab_count, tab)
        if new_update.nil?
          formatted << line
          next
        end
        formatted << line.sub(update, new_update)
      end
      formatted.join("\n")
    end

    def self.format_inserts(text, tab = "    ")
      formatted = []
      lines = text.split("\n")
      search = "INSERT INTO"
      lines.each do |line|
        first = line.strip.split(" ").first
        if first != "INSERT"
          formatted << line
          next
        end

        tab_count = self.get_tab_count(line, tab)
        insert = line.strip[search.size + 1..]
        new_insert = self.format_insert(insert, tab_count, tab)
        if new_insert.nil?
          formatted << line
          next
        end
        formatted << line.sub(insert, new_insert)
      end
      formatted.join("\n")
    end

    def self.format_selects(text, tab = "    ")
      formatted = []
      lines = text.split("\n")
      lines.each do |line|
        first = line.strip.split(" ").first
        if first != "SELECT"
          formatted << line
          next
        end

        tab_count = self.get_tab_count(line, tab)
        select_sql = line.strip[first.size + 1..]
        new_select = self.format_select(select_sql, tab_count, tab)
        if new_select.nil?
          formatted << line
          next
        end
        formatted << line.sub(select_sql, new_select)
      end
      formatted.join("\n")
    end

    def self.format_wheres(text, tab = "   ")
      formatted = []
      text.split("\n").each do |line|
        first = line.strip.split(" ").first
        if first != "WHERE"
          formatted << line
          next
        end

        tab_count = self.get_tab_count(line, tab)
        predicate = line.strip[first.size + 1..]
        new_predicate = self.format_predicate(predicate, tab_count, tab)
        if new_predicate.nil?
          formatted << line
          next
        end
        formatted << line.sub(predicate, new_predicate)
      end

      formatted.join("\n")
    end

    private

    def self.format_set(s, tab_count = 0, tab = "    ")
      return s if s.nil?
      parts = []
      builder = ""
      parenthesis = 0
      s.split("").each do |c|
        parenthesis += 1 if c == "("
        parenthesis -= 1 if c == ")"
        if c == ","
          if parenthesis > 0
            builder << c
          else
            parts << builder
            builder = ""
          end
        else
          builder << c
        end
      end
      parts << builder unless builder.empty?
      "\n#{parts.map { |p| "#{tab * (tab_count + 1)}#{p.strip}" }.join(",\n")}"
    end

    def self.format_update(s, tab_count = 0, tab = "    ")
      return s if s.nil?
      "\n#{tab * (tab_count + 1)}#{s}"
    end

    def self.format_insert(s, tab_count = 0, tab = "    ")
      return s if s.nil?
      formatted = []
      if s.include? ") VALUES ("
        tokens = s.split(") VALUES (")
        table = tokens[0][..tokens[0].index("(") - 2]
        columns = tokens[0][tokens[0].index("(") + 1..]
        values = tokens[1][..-2]
        formatted << "\n#{tab * (tab_count + 1)}#{table}"
        formatted << "#{tab * (tab_count + 2)}(#{columns})"
        formatted << "#{tab * (tab_count + 1)}VALUES"
        if s.end_with? ");"
          formatted << "#{tab * (tab_count + 2)}(#{values}"
        else
          formatted << "#{tab * (tab_count + 2)}(#{values})"
        end
      end
      formatted.join("\n") unless formatted.empty?
    end

    def self.format_select(s, tab_count = 0, tab = "    ")
      return s if s.nil?

      tokens = s.split(", ")
      "\n#{tokens.map { |t| "#{tab * (tab_count + 1)}#{t}" }.join(",\n")}"
    end

    def self.format_predicate(s, tab_count = 0, tab = "    ")
      return s if s.nil?
      indented = []
      formatted = []
      builder = []

      tokens = s.split(" ")
      tokens.each do |t|
        if %w[AND OR].include? t
          formatted << builder.join(" ") unless builder.empty?
          builder = [t]
        else
          builder << t
        end
      end
      formatted << builder.join(" ")

      level = tab_count
      formatted.each_with_index do |f, i|
        indented << "#{tab * (level + 1)}#{f}"
        level -= f.count(")")
        level += f.count("(")
      end

      "\n#{indented.join("\n")}"
    end

    def self.get_tab_count(line, tab = "    ")
      tab_count = 0
      while line.start_with? tab
        tab_count += 1
        line = line.sub(tab, "")
      end
      tab_count
    end
  end
end
