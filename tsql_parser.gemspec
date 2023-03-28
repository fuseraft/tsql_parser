Gem::Specification.new do |s|
    s.name        = "tsql_parser"
    s.version     = "0.0.6"
    s.summary     = "A very light-weight and opinionated T-SQL parser and formatter."
    s.description = "A very light-weight and opinionated T-SQL parser and formatter."
    s.authors     = ["Scott Stauffer"]
    s.email       = "scott@fuseraft.com"
    s.files       = Dir['lib/**/*.rb']
    s.metadata    = { 
      "source_code_uri" => "https://github.com/scstauf/tsql_parser",
      "documentation_uri" => "https://www.rubydoc.info/github/scstauf/tsql_parser"
    }
    s.homepage    = "https://rubygems.org/gems/tsql_parser"
    s.license     = "MIT"
    s.required_ruby_version = '>= 2.7.0'
  end