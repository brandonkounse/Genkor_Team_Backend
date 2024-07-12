# frozen_string_literal: true

# Orchestration to get members and stats to send to front end
class TeamMembersController < ApplicationController
  def index
    members_with_stats = fetch_members_with_stats
    render json: filter_member_stats(members_with_stats)
  end

  private

  def fetch_members_with_stats
    team_members = firebase_service.get_all_team_member_data
    team_members.each_value.map { |member| build_member_data(member) }
  end

  def build_member_data(member)
    {
      name: member['profile_info']['name'],
      profile_info: extract_profile_info(member),
      ranked_stats: fetch_ranked_stats(member)
    }
  end

  def extract_profile_info(member)
    {
      profile_icon_id: member['profile_info']['profile_icon_id'],
      summoner_level: member['profile_info']['summoner_level']
    }
  end

  def fetch_ranked_stats(member)
    league_service.get_summoner_ranked_stats(member['profile_info']['summoner_id'])
  end

  def filter_member_stats(members)
    members.map do |member|
      filtered_stats = member[:ranked_stats].transform_values do |queue_stats|
        queue_stats.except('summonerId')
      end
      member.merge(ranked_stats: filtered_stats)
    end
  end

  def firebase_service
    @firebase_service ||= FirebaseService.new
  end

  def league_service
    @league_service ||= LeagueApiService.new
  end
end
