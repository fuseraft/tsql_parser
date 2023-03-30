# tsql_parser

A very light-weight and opinionated T-SQL parser and formatter.

## Installation

```
gem install tsql_parser
```

## Methods

There are two methods on `TSqlParser` and those are: `TSqlParser#parse` and `TSqlParser#format`.

**parse(sql) → hash_array**
Parses a T-SQL string and returns a hash array containing metadata about the tokens.

**format(sql, tab_count = 0, tab = "    ") → formatted_sql_string**
Parses and formats a T-SQL string. The default tab count is `0` and the default tab string is four white-space characters.

## Usage

```ruby
require "tsql_parser"

file = File.expand_path("~/path/to/tsql_script.sql")
tsql = File.read(file)

# Print formatted T-SQL to STDOUT.
puts TSqlParser.format(tsql, 0)
```

## Contributions

I would love contributions from the open-source community. 

Here is a link to the [Quickstart on Contributing to Projects](https://docs.github.com/en/get-started/quickstart/contributing-to-projects)