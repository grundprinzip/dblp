$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require File.dirname(__FILE__) + '/dblp/parser'
require File.dirname(__FILE__) + '/dblp/grabber'


module Dblp
  
  class << self

    def run(file, options)

      if !file || !File.exists?(file)
        puts "You need to specify a filename"
        exit
      end
      
      # Clean file to parse
      file = File.basename(file, File.extname(file)) + ".aux"
      overall_size = 0
      
      parser = Dblp::Parser.new(file)
      grabber = Dblp::Grabber.new(options)
      File.open(options.output, "w+") do |f|
        f.puts parser.parse.inject([]) {|m, l| 
            m << grabber.grab(l)
            overall_size = m.size
            m
          }.uniq.join("\n")
      end
      
      if options.bibtex
        res = system("bibtex #{File.basename(file, File.extname(file))}")
        puts res
      end
      
      # Output
      puts "Stored #{overall_size} entries in #{options.output}"
      
    end
  
  end
  
end

