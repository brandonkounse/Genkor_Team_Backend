# frozen_string_literal: true

# Orchestration to get members and stats to send to front end
class TeamMembersController < ApplicationController
  before_action :set_cors_headers

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
      position: member['profile_info']['position'],
      profile_info: extract_profile_info(member['profile_info']['puuid']),
      ranked_stats: fetch_ranked_stats(member)
    }
  end

  def extract_profile_info(puuid)
    league_service.get_summoner_profile_info(puuid).filter do |key, _value|
      %i[profile_icon_id summoner_level].include?(key)
    end
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

  def set_cors_headers
    return unless request.headers['Origin'] == 'https://genkor.lol'

    headers['Access-Control-Allow-Origin'] = 'https://genkor.lol'
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
  end
end
