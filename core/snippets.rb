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
def getMemUsageMac(pid=nil) # Mac only? :< 
  `ps -o rss= -p #{(pid or Process.pid)}`.to_s.chomp.strip+"k"
end
