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
Array.class_eval do
    def includeV? keyword
      o={}
      self.each_with_index{|k,i|
        if k.to_s.include? keyword then
          o[i]=k
        end
      }
      o
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
    !windows?
  end

  def linux?
    unix? and not mac?
  end
end
def getMemUsage(pid=nil) # Mac only? :< I dont think so...
  #`ps -o rss= -p #{(pid or Process.pid)}`.to_s.chomp.strip+"k"
  `ps -o rss= -p #{(Process.pid)}`.chomp.to_i/1024.0
end
def konamicode
  return "↑ ↑ ↓ ↓ ← → ← → B A"
end
