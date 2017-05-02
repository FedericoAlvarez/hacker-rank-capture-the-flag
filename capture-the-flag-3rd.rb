require 'nokogiri'
require 'open-uri'
require 'set'

@links = Set.new
@secretsWords = Set.new

class HackerRankURL
  @document
  @url

  def initialize(url)
    @document = Nokogiri::HTML(open("http://cdn.hackerrank.com/hackerrank/static/contests/capture-the-flag/infinite/#{url}.html"))
    @url = url
  end

  def getLinks()
    newLinks = @document.xpath("//a")
    return newLinks
  end

  def getSecretWord()
    return @document.css("font")[0].content
  rescue
    return ""
  end

  def getURL()
    return @url
  end

end

def transverse(web)
  if !@links.include? web.getURL
    @links.add web.getURL
    unless web.getSecretWord.empty?
      @secretsWords.add web.getSecretWord
    end
    web.getLinks.each{|a| transverse(HackerRankURL.new(a.content))}
  end
end

web = HackerRankURL.new("qds")
transverse(web)

@secretsWords.each { |a|  puts a}
