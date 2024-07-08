class FirebaseController < ApplicationController
  def get_team_members
    firebase_service = FirebaseService.new
    league_service = LeagueApiService.new

    team_members = firebase_service.get_all_team_member_data
    members_with_ranked_stats = team_members.each_value.map do |v|
      {
        name: v['profile_info']['name'],
        profile_info: {
          profile_icon_id: v['profile_info']['profile_icon_id'],
          summoner_level: v['profile_info']['summoner_level']
        },
        ranked_stats: league_service.get_summoner_ranked_stats(v['profile_info']['summoner_id'])
      }
    end

    members_with_filtered_stats = members_with_ranked_stats.map do |member|
      filtered_ranked_stats = member[:ranked_stats].transform_values do |queue_stats|
        queue_stats.except('summonerId')
      end
      member.merge(ranked_stats: filtered_ranked_stats)
    end

    render json: members_with_filtered_stats
  end
end
