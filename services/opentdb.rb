require "httparty"

class Opentdb
  include HTTParty
  base_uri "https://opentdb.com/api.php"

  def self.index
    get("/?amount=10")
  end
end
