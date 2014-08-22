# Containing things that are small, but still useful
require "uri"
String.class_eval do
    def is_valid_url?
        uri = URI.parse self
        uri.kind_of? URI::HTTP
    rescue URI::InvalidURIError
        false
    end
end
class OS
  def windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def mac?
   (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def unix?
    !OS.windows?
  end

  def linux?
    OS.unix? and not OS.mac?
  end
end
def getMemUsage(pid=nil) # Mac only? :< I dont think so...
  `ps -o rss= -p #{(pid or Process.pid)}`.to_s.chomp.strip+"k"
end
def konamicode
  return "↑ ↑ ↓ ↓ ← → ← → B A"
end
