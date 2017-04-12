module Fluent
    class TextParser
	class PostgreSQLCSV < ValuesParser
	  Fluent::Plugin.register_parser('multiline_pgsql_csv', self)

	  config_param :format_firstline, :string, :default => nil

	  def initialize
	    super
	    require 'csv'
	  end

	  def configure(conf)
	    super

	    if @format_firstline
	      check_format_regexp(@format_firstline, 'format_firstline')
	      @firstline_regex = Regexp.new(@format_firstline[1..-2])
	    end
	  end

	  def parse(text)
	    if block_given?
	      yield values_map(CSV.parse_line(text))
	    else
	      return values_map(CSV.parse_line(text))
	    end
	  end

	  def has_firstline?
	    !!@format_firstline
	  end

	  def firstline?(text)
	    @firstline_regex.match(text)
	  end

	  private

	  def check_format_regexp(format, key)
	    if format[0] == '/' && format[-1] == '/'
	      begin
		Regexp.new(format[1..-2])
	      rescue => e
		raise ConfigError, "Invalid regexp in #{key}: #{e}"
	      end
	    else
	      raise ConfigError, "format_firstline should be Regexp, need //: '#{format}'"
	    end
	  end
	end
    end
end

