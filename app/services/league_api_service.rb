# frozen_string_literal: true

# Service file for interfacing with Riot Games API
class LeagueApiService
  extend Limiter::Mixin

  limit_method :get_summoner_ranked_stats, rate: 100
  limit_method :get_summoner_profile_info, rate: 1600
  limit_method :get_summoner_puuid, rate: 1000

  API_KEY = ENV.fetch('RIOT_LEAGUE_API_KEY', nil)
  ACCOUNT_V1 = ENV.fetch('ACCOUNT_V1_URL', nil)
  SUMMONER_V4 = ENV.fetch('SUMMONER_V4_URL', nil)
  LEAGUE_V4 = ENV.fetch('LEAGUE_V4_URL', nil)

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

  # API call to get a summoner's ranked stats
  def get_summoner_ranked_stats(summoner_id)
    response = RestClient.get("#{LEAGUE_V4}/#{summoner_id}?api_key=#{API_KEY}")
    data = JSON.parse(response.body)
    format_ranked_data(data)
  end

  # API call to return hash of summoner_id, profile_icon_id, summoner_level, and puuid
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

  private

  def headers
    { 'X-Riot-Token' => API_KEY }
  end

  # API call for puuid only
  def get_summoner_puuid(summoner_name, summoner_tag)
    response = RestClient.get("#{ACCOUNT_V1}/#{summoner_name}/#{summoner_tag}?api_key=#{API_KEY}")
    data = JSON.parse(response.body)
    { puuid: data['puuid'] }
  end

  def format_ranked_data(data)
    formatted_data = {}
    data.each do |obj|
      stats = {}
      stats['leagueId'] = obj['leagueId']
      stats['queueType'] = obj['queueType']
      stats['tier'] = obj['tier']
      stats['rank'] = obj['rank']
      stats['wins'] = obj['wins']
      stats['losses'] = obj['losses']
      stats['summonerId'] = obj['summonerId']
      formatted_data[obj['queueType']] = stats
    end
    formatted_data
  end
end
