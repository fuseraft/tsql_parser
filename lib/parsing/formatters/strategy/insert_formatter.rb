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
#   parsing/formatters/insert_formatter.rb
# object:
#   TSqlParser::Parsing::Formatters::InsertFormatter

module TSqlParser::Parsing::Formatters
  require_relative "base_formatter"

  class InsertFormatter < BaseFormatter
    def format(text, tab = Defaults.get_default_tab)
      formatted = []
      lines = text.split("\n")
      search = "INSERT INTO"
      lines.each do |line|
        first = line.strip.split(" ").first
        next if first.nil?
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

    private

    def format_insert(s, tab_count = Defaults.get_default_tab_count, tab = Defaults.get_default_tab)
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
  end
end
