require_relative '../services/summoner_api_service'

class SummonersController < ApplicationController
  def show
    @puuid = SummonerApiService.fetch_summoner_PUUID(params[:name], params[:tag])
    puts @puuid
    render json: @puuid
  rescue RestClient::ExceptionWithResponse => e
    render json: { error: e.response }, status: :bad_request
  end
end