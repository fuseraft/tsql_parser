# TSqlParser

A very light-weight and opinionated T-SQL parser and formatter.

The **`tsql_parser`** library can be used to format gnarly/headache-inducing T-SQL stored procedure code (> 1000 LoC) into easy to understand T-SQL. 

It can also be used to tokenize a T-SQL string and produce a hash array containing metadata about each token in the T-SQL string.

The parser implementation rolls its own lexical analysis and tokenization instead of leaning on generators like Lex, YACC, or Bison.

Contributions welcome! Please submit any issues you discover and if you want to fix something, please fork and submit a pull request!

# Installation

## Terminal

```bash
$ gem install tsql_parser
```

## Gemfile

```ruby
source "https://rubygems.org"
gem "tsql_parser", "~> 0.1.6"
```

# Example Usage

Here is an example of printing formatted T-SQL to the terminal.
```ruby
require "tsql_parser"

file = File.expand_path("~/path/to/tsql_script.sql")
tsql = File.read(file)

puts TSqlParser.format(tsql)
```

# TSqlParser

This is the facade for working with the library.

## Methods

### `TSqlParser#parse(sql) → hash_array`

- Parses a T-SQL string and returns a hash array containing metadata about the tokens.

### `TSqlParser#format(sql, tab_count = 0, tab = "    ") → formatted_sql_string`

- Parses and formats a T-SQL string. The default tab count is `0` and the default tab string is four white-space characters.

# TSqlParser::Parsing::Tokenizer

## Tokenizer Methods

### `Tokenizer#tokenize(tsql_string) → hash_array`

- Tokenizes a T-SQL string into a hash array of tokens.

# Configuration

I'm still building out the configurability of the tokenization, parsing, and formatter.

### `Defaults#set_default_tab_count(tab_count = 0)`

- Sets the default tab count to use during formatting.

### `Defaults#set_default_tab(tab = "    ")`

- Sets the default tab string to use during formatting.

### `Defaults#set_default_single_char_tokens(delim_array=[])`

- Sets the list of recognized character tokens.

#### Example
```ruby
TSqlParser::Parsing::Defaults.set_default_single_char_tokens ["(", ",", ")", "=", "+", "-", "%", "/", "*", "<", "!", ">", "'", "[", "]", ";"]
```

### `Defaults#set_default_delimiters(delim_array=[])`

* Sets the list of token-separators.

#### Example
```ruby
TSqlParser::Parsing::Defaults.set_default_delimiters [" ", "\n", "\t"]
```

# Contributions

I would love contributions from the open-source community. 

Here is a link to the [Quickstart on Contributing to Projects](https://docs.github.com/en/get-started/quickstart/contributing-to-projects)