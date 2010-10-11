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
      pres = content.scan(/<pre>(.*?)<.pre>/mix)
      
      if pres

        # First handle main entry
        result = []
        result << pres[0][0].gsub(/(<.*?>)/, "").gsub(/^\s+title\s+=\s+\{(.*?)\},/m, "  title     = {{\\1}},")

        # Find the crossref
        if pres.size > 1
          booktitle = pres[1][0].match(/^\s+title\s+=\s+\{(.*?)\},/m)
          if booktitle
            result[0].gsub!(/^\s+booktitle\s+=\s+\{(.*?)\},/m, "  booktitle = {{#{booktitle[1]}}},")
            result[0].gsub!(/^\s+crossref\s+=\s+\{(.*?)\},/m, "")
          end
        end
        result
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
          #CiteseerGrabber.new.grab(key)
          []
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
