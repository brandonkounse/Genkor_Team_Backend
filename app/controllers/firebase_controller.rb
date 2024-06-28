class FirebaseController < ApplicationController
  def get_team_members
    firebase_service = FirebaseService.new
    render json: firebase_service.get_all_team_members_names
  end

  def get_team_members_stats
    firebase_service = FirebaseService.new
    league_service = LeagueApiService.new

    team_members = firebase_service.get_all_team_member_data
    summoner_ids = firebase_service.get_all_team_member_summoner_ids
    ranked_stats = summoner_ids.map { |id| league_service.get_summoner_ranked_stats(id) }

    stats = team_members.map do |name, rank_stats|
      member_stats = ranked_stats.find { |stats| stats['summonerId'] == team_members['summoner_id'] }

      filtered_stats = member_stats.transform_values do |stats|
        stats.except('summonerId')
      end

      {
        "#{name}" => { 
          ranked_stats: filtered_stats
        },
      }
    end
    render json: stats
  end
end
