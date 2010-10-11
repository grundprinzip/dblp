require File.dirname(__FILE__) + '/test_helper.rb'

class TestDblp < Test::Unit::TestCase

  def setup
  end
  
  def test_parser
    
    p = Dblp::Parser.new(File.dirname(__FILE__) + "/test.aux")
    result = p.parse
    
    assert_equal 5, result.size
    assert_equal "conf/btw/JacobsA07", result.first
    assert_equal "DBLP:conf/cidr/StonebrakerBCCGHHLRZ07", result[1]
    
  end
  
  def test_grabber
    
    g = Dblp::Grabber.new
    
    res = g.grab("DBLP:conf/btw/JacobsA07")
    assert res.size == 1
    
    res = g.grab("DBLP:conf/icde/ZukowskiHNB06")
    
    res = g.grab("DBLP:conf/btw/JacobsAss07")
    assert res.size == 0
  end
  
  
  # def test_citeseer
    
  #   g = Dblp::CiteseerGrabber.new
  #   res = g.grab("graefe91data")
  #   assert res.size == 1
    
  #   res = g.grab("nixnurnix")
  #   assert res.size == 0
    
  # end
  
end
