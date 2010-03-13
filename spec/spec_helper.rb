require File.join(File.dirname(__FILE__), '..', 'web_archiver')
Dir["#{File.dirname(__FILE__)}/support/*.rb"].each {|f| require f}

require 'fakeweb'
FakeWeb.allow_net_connect = false

SAMPLE_HTML_DIR = File.join(File.dirname(__FILE__), 'sample_html')

module WebArchiver
  # different dir for testing, make this configurable in future
  ARCHIVE_DIR = File.join(ROOT, 'archive_test')
end

Spec::Runner.configure do |config|
  
  config.before(:each) do
    p system("rm -rf #{WebArchiver::ARCHIVE_DIR}")
  end
  
end