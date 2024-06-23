require_relative '../services/summoner_api_service'

class SummonersController < ApplicationController
  def show
    service = SummonerApiService.new
    @puuid = service.fetch_summoner_PUUID('Kounse', 'NA1') # placeholder for now
    puts @puuid
    render json: @puuid
  rescue RestClient::ExceptionWithResponse => e
    render json: { error: e.response }, status: :bad_request
  end
end