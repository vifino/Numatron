# Eval.in class, for interfacing with it.
# Heavily based on the work of Mon_Ouie
# Made by vifino
require 'net/http'
require 'nokogiri'
class EvalIn
	attr_reader :lang
	attr_reader :MaxLength
	class FormatError < StandardError; end
  class CommunicationError < StandardError; end
	@lang = "ruby/mri-2.1"
	def lang(lang="ruby/mri-2.1")
		@lang = lang
	end
	MaxLength = 80
	def eval(lang, code)
		result = Net::HTTP.post_form(URI("https://eval.in/"), "utf8" => "λ", "code" => template(lang)+(code or ""), "execute" => "on", "lang" => (lang or @lang), "input" => "")
		if result.is_a? Net::HTTPFound
    		location = URI(result['location'])
        location.scheme = "https"
        location.port = 443
        body = Nokogiri(Net::HTTP.get(location))
        if output_title = body.at_xpath("*//h2[text()='Program Output']")
          output = output_title.next_element.text
					begin
          	first_line = output.each_line.first.chomp
          	needs_ellipsis = output.each_line.count > 1 || first_line.length > MaxLength
          	out = "#{first_line[0, MaxLength]}#{'...' if needs_ellipsis} (#{location})"
					rescue => e # no output
						out = "No output (#{location})"
					end
					#if out.match("^\/tmp\/(.*):(\d*):in") then
					#	return out.gsub("^\/tmp\/(.*):(\d*):","")
					#else
						return out
					#end
        else
          raise FormatError, "couldn't find program output"
        end
      else
        raise CommunicationError, result
      end
    end
		def template(lang)
			#if lang.match("ruby") then
			#return "begin; puts eval(DATA.read).inspect;rescue => e; $stderr.puts \"\#{e.class}: \#{e}\"; end; "
			#	return ""
			#end
			return ""
		end
end
