require File.join(File.dirname(__FILE__), '..', 'spec_helper')

module WebArchiver
  describe Crawler do
    
    it "should crawl a single page and save it in archive dir" do
      uri = URI.parse('http://someurl.com/path/')
      html = File.read(File.join(SAMPLE_HTML_DIR, 'single_page_no_links.html'))
      FakeWeb.register_uri(:get, uri, :body => html)
      
      output = StringIO.new
      
      crawler = Crawler.new(uri)
      crawler.go!
      
      base_dir = File.join(ARCHIVE_DIR, 'someurl.com')
      File.should exist(base_dir)
      File.should be_a_directory(base_dir)
      
      first_level_dir = File.join(ARCHIVE_DIR, 'someurl.com', 'path')
      File.should exist(first_level_dir)
      File.should be_a_directory(first_level_dir)
      
      index_html = File.join(ARCHIVE_DIR, 'someurl.com', 'path', 'index.html')
      File.should exist(index_html)
      File.read(index_html).should == html
      
    end
  end
end