require 'open-uri'

module Dblp
  
  class Grabber
    
    # Const url to fetch from
    DBLP_URL = "http://dblp.uni-trier.de/rec/bibtex/"
    
    def read_html(url)
      content = ""
      open(url) do |f|
        content = f.read
      end
      content
    end

    def extract_pre(content)
      # extract the bibtex code, that is in pre tags
      result = content.scan(/<pre>(.*?)<.pre>/mix)
      if result
        result.inject([]) do |m, k|
          #m[k[0].match(/@.*\{(.*?),/)[1].gsub(/(<.*?>)/, "")] = k[0].gsub(/(<.*?>)/, "")
          m << k[0].gsub(/(<.*?>)/, "")
          m
        end
      else
        []
      end
    end
    
    
    def grab(key)
      begin 
        # Check the key 
        if key =~ /DBLP:/
          content = read_html(DBLP_URL + key.gsub("DBLP:", ""))
          extract_pre(content)
        else
          CiteseerGrabber.new.grab(key)
        end
      rescue
        []
      end
    end
    
  end
  
  class CiteseerGrabber < Grabber
    
    CITESEE_URL = "http://citeseer.ist.psu.edu/"
    
    def grab(key)
      begin
        content = read_html(CITESEE_URL + key + ".html")
        extract_pre(content)
      rescue
        []
      end
    end
    
  end
  
end