# Service object for interfacing with Riot Games API

require_relative '../models/genkor_team'

class LeagueApiService
  API_KEY = ENV['RIOT_LEAGUE_API_KEY']
  ACCOUNT_V1 = ENV['ACCOUNT_V1_URL']
  SUMMONER_V4 = ENV['SUMMONER_V4_URL']

  def get_team_profile_information(summoners)
    team = []
    summoners.each do |summoner|
      summoner.each do |name, tag|
        member_puuid = get_summoner_puuid(name, tag)
        member_profile_info = get_summoner_profile_info(member_puuid[:puuid])
        team.push({ profile_info: member_profile_info })
      end
    end
    team
  end

  private

  def headers
    { 'X-Riot-Token' => API_KEY }
  end

  def get_summoner_puuid(summoner_name, summoner_tag)
    response = RestClient.get("#{ACCOUNT_V1}/#{summoner_name}/#{summoner_tag}?api_key=#{API_KEY}")
    data = JSON.parse(response.body)
    { puuid: data['puuid'] }
  end

  def get_summoner_profile_info(puuid)
    response = RestClient.get("#{SUMMONER_V4}/#{puuid}?api_key=#{API_KEY}")
    data = JSON.parse(response.body)
    {
      summoner_id: data['id'],
      profile_icon_id: data['profileIconId'],
      summoner_level: data['summonerLevel'],
      puuid: data['puuid']
    }
  end
end