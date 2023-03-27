# tsql_parser
A very light-weight and opinionated T-SQL parser and formatter.

## Methods

`TSqlParser#parse`

`TSqlParser#format`

## Usage

```ruby
require 'tsql_parser'

sql = File.read(File.expand_path('~/path/to/script.sql'))
puts TSqlParser.format(sql, 0)
```