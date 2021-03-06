require 'rubygems'
require 'nokogiri'
require 'net/http'

module WebArchiver
  class Crawler
    
    DELAY = 0.5
    
    attr_accessor :logger
    
    def initialize(base_uri)
      base_uri = URI.parse(base_uri) unless base_uri.is_a?(URI)
      @base_uri = base_uri      
      
      @logger = STDOUT
      @found_uris = []
      @history = []
    end
    
    def visit_link?(uri)
      uri.path.match /thread|Profile|page/
    end
    
    def log_visit(uri)
      uri_string = uri.to_s
      @history << uri_string unless visited?(uri_string)
    end
    
    def visited?(uri)
      @history.include? uri.to_s
    end
    
    def href_to_uri(href)
      uri = URI.parse(href)
      
      if uri.host.nil?
        tmp_uri = @base_uri.clone
        tmp_uri.path = href.split('?').first
        tmp_uri.query = href.split('?').last
        uri = tmp_uri
      end
      
      return uri
    end
    
    def collect_links(hrefs)
      uris = hrefs.map { |href| href_to_uri(href) }
      
      @found_uris << uris
      @found_uris.flatten!
      @found_uris.uniq!
    end
    
    def next_uri
      @found_uris.each do |uri|
        next unless uri.host == @base_uri.host
        
        if not visited?(uri) and visit_link?(uri)
          return uri
        end
      end
      
      return false
    end
    
    def get(uri)
      Net::HTTP.get(uri)
    end
    
    def extract_link_hrefs(html)
     links = Nokogiri::HTML(html).xpath('//a')
     hrefs = []
     if links.length > 0
       hrefs = links.map { |link| link.attribute('href').to_s }
     end
    
     return hrefs
    end
    
    def go!
      
      archive_dir = ARCHIVE_DIR
      uri = @base_uri
      
      while true
        logger.puts "visiting #{uri.to_s}"
        
        # remove last secontion of url ie (domain.com/1/2/3 -> domain.com/1/2)
        uri_path_without_last_part = uri.path.gsub(/\/([^\/]*)$/, '')
        this_archive_base_dir = File.join(archive_dir, uri.host, uri_path_without_last_part)
        
        FileUtils.mkdir_p( this_archive_base_dir )
        
        if file_name_match = uri.path.match(/\/([^\/]+)$/)
          file_name = file_name_match[1]
        else
          file_name = 'index'
        end
        
        file_name += '.html'
        file_path = File.join(this_archive_base_dir, file_name)
        
        page = get(uri)
        
        File.open(file_path, 'w') do |f|
          f.puts page.gsub(/href="\/([^"]*)"/m, 'href="file://' + this_archive_base_dir + "/\\1.html\"")
        end
        
        log_visit(uri)
        collect_links( extract_link_hrefs(page) )
        
        sleep(DELAY)
        break unless uri = next_uri
      end
      
      logger.puts "Finished crawling!"
      logger.puts "#{@found_uris.length} links collected"
      logger.puts "#{@history.length} pages scraped"
    end
  end
end
