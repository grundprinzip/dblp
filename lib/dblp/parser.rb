module Dblp
  
  class Parser
    
    def initialize(filename)
      @filename = filename
      @map = {}
    end
    
    def parse
      File.readlines(@filename).inject([]) {|m, l|
          cnt = l.match(/\\citation\{(.*?)\}/)
          
          if cnt
            cnt[1].split(",").each do |t|
              m << t
            end
          end
          m
        }.uniq
    end
    
  end
  
end