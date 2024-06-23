# Service object for interfacing with Riot Games API

class SummonerApiService
  BASE_URL = 'https://americas.api.riotgames.com/riot/account/v1/accounts/by-riot-id/'

  def initialize
    @api_key = ENV['RIOT_LEAGUE_API_KEY']
  end

  def fetch_summoner_PUUID(summoner_name, summoner_tag)
    response = RestClient.get("#{BASE_URL}/#{summoner_name}/#{summoner_tag}?api_key=#{@api_key}")
    JSON.parse(response.body['puuid'])
  end

  private

  def headers
    { 'X-Riot-Token' => @api_key }
  end
end