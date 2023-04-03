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
#   parsing/config/defaults.rb
# object:
#   TSqlParser::Parsing::Defaults

module TSqlParser::Parsing
  class Defaults
    @@default_single_char_tokens = ["(", ",", ")", "=", "+", "-", "%", "/", "*", "<", "!", ">", "'", "[", "]", ";"]
    @@default_delimiters = [" ", "\n", "\t"]
    @@default_tab_count = 0
    @@default_tab = "    "

    def self.set_default_tab_count(tab_count = 0)
      @@default_tab_count = tab_count
    end

    def self.set_default_tab(tab = "    ")
      @@default_tab = tab
    end

    def self.set_default_single_char_tokens(single_char_tokens = ["(", ",", ")", "=", "+", "-", "%", "/", "*", "<", "!", ">", "'", "[", "]", ";"])
      @@default_single_char_tokens = single_char_tokens
    end

    def self.set_default_delimiters(delimiters = [" ", "\n", "\t"])
      @@default_delimiters = delimiters
    end

    def self.get_default_single_char_tokens
      @@default_single_char_tokens
    end

    def self.get_default_delimiters
      @@default_delimiters
    end

    def self.get_default_tab_count
      @@default_tab_count
    end

    def self.get_default_tab
      @@default_tab
    end
  end
end
