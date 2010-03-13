Dir["#{File.dirname(__FILE__)}/lib/**/*.rb"].each {|f| require f}

module WebArchiver
  ROOT = File.dirname(__FILE__)
  ARCHIVE_DIR = File.join ROOT, 'archive'
end