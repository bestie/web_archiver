# Web Archiver

Work in progress!

This is a dead simple single threaded, in memory, text only web archiver.

Currently this only really works for its original purpose of archiving network54 forums (which it does brilliantly) but it may evolve soon.

## Usage
  `irb > require 'web_archiver'`
  
  `irb > WebArchiver::Crawler.new('http://mydomain.com/').go!`

## Wish List

* Complete test suite
* More configuration (which links it should follow etc.)
* Follow redirects (possibly replace Net::HTTP with webrat)
* Useful logging options
* CLI controller
* Pull down css, javascript, images 