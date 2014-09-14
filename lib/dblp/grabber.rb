
require 'open-uri'



module Dblp
  
  class Grabber
    
    # Const url to fetch from
    DBLP_URL = "http://dblp.uni-trier.de/rec/bibtex/"

    def initialize(options = nil)
      @options = options
    end
    
    def read_html(url)
      content = ""
      open(url) do |f|
        content = f.read
      end
      content
    end

    # Extracts all relevant information from the <pre> elements from
    # the dblp page. There is one special case to handle. If there are
    # multiple <pre> elements there is a cross reference used. We have
    # to check if we include the cross reference or extract the short
    # version.
    def extract_pre(content)
      # extract the bibtex code, that is in pre tags
      pres = content.scan(/<pre>(.*?)<.pre>/mix)
      
      if pres

        # First handle main entry
        result = []
        return [] if pres.size == 0

        result << pres[0][0].gsub(/(<.*?>)/, "").gsub(/^\s+title\s+=\s+\{(.*?)\},/m, "  title     = {{\\1}},")

        # Find the crossref in the second <pre>
        if pres.size > 1

          if @options && @options.crossref
            result << pres[1][0].gsub(/(<.*?>)/, "").gsub(/^\s+title\s+=\s+\{(.*?)\},$/m, "  title     = {{\\1}},")
          else
            booktitle = pres[1][0].match(/^\s+title\s+=\s+\{(.*?)\},$/m)


            # If we find a booktitle, replace the book title with the
            # one from the crossref
            if booktitle
              unless @options.short
                cleantitle = booktitle[1].gsub(/\n|\t|\s+/, " ")
                result[0].gsub!(/^\s+booktitle\s+=\s+\{(.*?)\},$/m){|match|
                  "  booktitle = {{#{cleantitle}}},"
                }
              end

              publisher = pres[1][0].match(/^\s+publisher\s+=\s+\{(.*?)\},/m)
              publisher_data = publisher ? "  publisher = {{#{publisher[1]}}}," : ""

              # TODO make cross ref handling configurable
              result[0].gsub!(/^\s+crossref\s+=\s+\{(.*?)\},/m, publisher_data)
            end
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
      rescue Exception => e
        puts e.message
        puts e.backtrace.inspect
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
