# frozen_string_literal: true

require 'rest-client'

# Service file for getting data from Firebase
class FirebaseService
  BASE_URL = ENV.fetch('FIREBASE_URL', nil)
  API_KEY = ENV.fetch('FIREBASE_API_KEY', nil)
  ADMIN_EMAIL = ENV.fetch('FIREBASE_ADMIN_EMAIL', nil)
  ADMIN_PASSWORD = ENV.fetch('FIREBASE_ADMIN_PASSWORD', nil)

  def initialize
    @id_token = get_id_token
  end

  def get_team_member_data(summoner_name)
    url = "#{BASE_URL}/#{summoner_name}.json?auth=#{@id_token}"
    response = RestClient.get(url)
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    handle_http_error(e)
  end

  def get_all_team_member_data
    url = "#{BASE_URL}/.json?auth=#{@id_token}"
    response = RestClient.get(url)
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    handle_http_error(e)
  end

  def get_all_team_members_names
    names = []

    get_all_team_member_data.each_key do |k|
      names.push(k)
    end
    names
  end

  def get_all_team_member_summoner_ids
    ids = []

    get_all_team_member_data.each_value do |value|
      ids.push(value['profile_info']['summoner_id'])
    end
    ids
  end

  def store_team_member_data(summoner_name, summoner_data)
    url = "#{BASE_URL}/#{summoner_name}.json?auth=#{@id_token}"
    payload = summoner_data.to_json
    response = RestClient.put(url, payload, headers)
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    handle_http_error(e)
  end

  private

  def headers
    { content_type: :json, accept: :json }
  end

  def handle_http_error(err)
    puts "Error: #{err.response}"
  end

  def get_id_token
    url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=#{API_KEY}"
    payload = {
      email: ADMIN_EMAIL,
      password: ADMIN_PASSWORD,
      returnSecureToken: true
    }.to_json

    response = RestClient.post(url, payload, headers)

    JSON.parse(response.body)['idToken']
  rescue RestClient::ExceptionWithResponse => e
    handle_http_error(e)
  end
end
