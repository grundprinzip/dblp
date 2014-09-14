require File.dirname(__FILE__) + '/test_helper.rb'
require 'ostruct'

class TestDblp < Test::Unit::TestCase

  def setup
    @options = OpenStruct.new
    @options.output = "dblp.bib"
    @options.bibtex = true
    @options.crossref = false
    @options.short = false
  end
  
  def test_parser
    
    p = Dblp::Parser.new(File.dirname(__FILE__) + "/test.aux")
    result = p.parse
    
    assert_equal 5, result.size
    assert_equal "conf/btw/JacobsA07", result.first
    assert_equal "DBLP:conf/cidr/StonebrakerBCCGHHLRZ07", result[1]
    
  end
  
  def test_grabber
    
    g = Dblp::Grabber.new(@options)
    
    res = g.grab("DBLP:conf/btw/JacobsA07")
    assert res.size == 1
    
    res = g.grab("DBLP:conf/icde/ZukowskiHNB06")
    
    res = g.grab("DBLP:conf/btw/JacobsAss07")
    assert res.size == 0
  end

  def test_grabber_special_chars
    g = Dblp::Grabber.new(@options)
    res = g.grab("DBLP:conf/icde/MinhasYAS08")
    puts res
    assert res.size == 1
  end


  def test_publisher
    g = Dblp::Grabber.new(@options)
    res = g.grab("DBLP:conf/btw/JacobsA07")
    assert_match /publisher/, res[0]
  end


  def test_crossref_not_set
    g = Dblp::Grabber.new(@options)
    res = g.grab("DBLP:conf/btw/JacobsA07")
    
    assert_equal 1, res.size
    assert_match /publisher/, res[0]
  end

  def test_crossref_set
    @options.crossref = true
    g = Dblp::Grabber.new(@options)
    res = g.grab("DBLP:conf/btw/JacobsA07")
    assert_equal 2, res.size
  end
end
