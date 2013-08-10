Gem::Specification.new do |s|
  s.name = "decorates_timestamps"
  s.summary = "Convenience methods for decorating timestamps with draper"
  s.author = "Mark Woods"
  s.version = "0.0.2"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {spec}/*`.split("\n")
  s.homepage = "http://github.com/thickpaddy/decorates_timestamps"
  s.license  = "MIT"

  s.add_dependency('draper')
  s.add_development_dependency("rspec")
  s.add_development_dependency("activerecord")
  s.add_development_dependency("activerecord-nulldb-adapter")
end
