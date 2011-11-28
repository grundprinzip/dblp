Gem::Specification.new do |s|
  s.name        = 'dblp'
  s.version     = '0.5.5'
  s.date        =  Time.now

  s.summary     = "DBLP"
  s.description = "Dynamically generate the bibtex file from your citations"
  s.authors     = ["Martin Grund"]
  s.email       = 'grundprinzip@gmail.com'
  s.homepage    = 'http://www.grundprinzip.de/tags/dblp'

  s.bindir	= "bin"
  s.executable	= "dblp"
  s.require_paths = ["lib"]

  s.files       = ["Rakefile", "bin/dblp","lib/dblp.rb", "lib/dblp/grabber.rb", "lib/dblp/parser.rb", "lib/dblp/query.rb", "lib/dblp/version.rb"]

  s.add_runtime_dependency('json', '>= 1.4.0')
end
