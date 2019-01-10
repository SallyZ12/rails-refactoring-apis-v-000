class GithubService

attr_reader :access_token

  def initialize(access_hash = nil)
    @access_token = access_hash["access_token"] if access_hash
  end

  def authenticate!(client_id, client_secret, code)

    response = Faraday.post "https://github.com/login/oauth/access_token" do |req|
      req.body = {client_id: client_id, client_secret: client_secret, code: code}
      req.headers['Accept'] = 'application/json'
    end
      access_hash = JSON.parse(response.body)
      @access_token = access_hash["access_token"]
  end

  def get_username
    user_response = Faraday.get "https://api.github.com/user" do |req|
      req.headers['Authorization'] = 'token ' + @access_token
      req.headers['Accept'] = 'application/json'
    end
    user_json = JSON.parse(user_response.body)
    user_json['login']
  end

  def get_repos
    response = Faraday.get "https://api.github.com/user/repos" do |req|
      req.headers['Authorization'] = 'token ' + @access_token
      req.headers['Accept'] = 'application/json'
    end
    repos_array = JSON.parse(response.body)
    repos_array.map {|repo|GithubRepo.new(repo)}
  end


  def create_repo(name)
    response = Faraday.post "https://api.github.com/user/repos" do |req|
      req.headers['Authorization'] = 'token ' + @access_token
      req.headers['Accept'] = 'application/json'
      req.body = {name: name}.to_json
    end
  end


end
