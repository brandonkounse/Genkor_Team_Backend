require 'rest-client'

class FirebaseService
  BASE_URL = ENV['FIREBASE_URL']
  API_KEY = ENV['FIREBASE_API_KEY']
  ADMIN_EMAIL = ENV['FIREBASE_ADMIN_EMAIL']
  ADMIN_PASSWORD = ENV['FIREBASE_ADMIN_PASSWORD']

  def initialize
    @id_token = get_id_token
  end

  def get_team_member_data(summoner_name)
    url = "#{BASE_URL}/#{summoner_name}.json?auth=#{@id_token}"
    response = RestClient.get(url)
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    puts "Error: #{e.response}"
    nil
  end

  def store_team_member_data(summoner_name, summoner_data)
    url = "#{BASE_URL}/#{summoner_name}.json?auth=#{@id_token}"
    payload = summoner_data.to_json
    response = RestClient.put(url, payload, headers)

    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    puts "Error: #{e.response}"
    nil
  end

  private

  def headers
    { content_type: :json, accept: :json }
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
    puts "Error: #{e.response}"
    nil
  end
end