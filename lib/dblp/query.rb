require 'net/http'
require 'rubygems'
require 'json'
require 'ostruct'

class DBLPQuery

  BASE_URI = "http://dblp.mpi-inf.mpg.de/autocomplete-php/autocomplete/ajax.php"

  attr_accessor :params, :result

  def initialize
    @result = []

    @params = {
      :name => "dblpmirror",
      :path => "/dblp-mirror/",
      :page => "index.php",
      :log => "/var/opt/completesearch/log/completesearch.error_log",
      :qid => 6,
      :navigation_mode => "history",
      :language => "en",
      :mcsr => 40,
      :mcc => 0,
      :mcl => 80,
      :hpp => 20,
      :eph => 1,
      :er => 20,
      :dm => 3,
      :bnm => "R",
      :ll => 2,
      :mo => 100,
      :accc => ":",
      :syn => 0,
      :deb => 0,
      :hrd => "1a",
      :hrw => "1d",
      :qi => 1,
      :fh => 1,
      :fhs => 1,
      :mcs => 20,
      :rid => 0,
      :qt => "H"
    }

  end


  def query(what)

    # Make some simple means of caching
    return if @params["query"] == what

    @params["query"] = what

    url = URI.parse(BASE_URI)
    req = Net::HTTP::Post.new(url.path)

    req.set_form_data(@params)
    res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }

    case res
    when Net::HTTPSuccess, Net::HTTPRedirection
      # OK
      puts "Success"
      body = extreact_from_body(res.body)
      parse_table(body)
      @result = parse_table(body)
    else
      res.error!
    end

  end


  def extreact_from_body(body)
    raw = body.split("\n")[27][11..-2].gsub("'", "\"")
    full = JSON.parse(raw)
    full["body"]
  end
  
  def parse_table(body)
    result = []

    body.scan(/<tr>(.*?)<\/tr>/m) do |match|
      
      cells = match[0].scan(/<td.*?>(.*?)<\/td>/m)
      next unless cells.size == 3
      
      obj = OpenStruct.new
      # First Cell is the cite key
      obj.cite = "DBLP:" << cells[0][0].match(/href="http:\/\/dblp\.uni-trier\.de\/rec\/bibtex\/(.*?)">/)[1]

      # second cell the link to the electronic version

      # Third cell is author + title
      obj.title = cells[2][0].gsub(/<.*?>/,"")

      result << obj
    end
    result
  end

  # Based on the last result that was fetched, a new cite key is returned
  # based on the position inside the result.
  def select(num)
    return if @result.size == 0 || @result.size < num
    return @result[num.abs].cite
  end

  def present
    @result.each_with_index do |item, i|
      puts "\t#{i+1}\t#{item.title}\n"
    end
  end

  def cite(num)
    "\\cite{#{select(num)}}"
  end

end

if __FILE__ == $0

  q = DBLPQuery.new
  q.query("Kossmann")

  q.present

  puts q.select(3)
  puts q.cite(3)

end
