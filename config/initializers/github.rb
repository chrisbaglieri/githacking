module Github
  def self.config
    unless defined?(@@config)
      github_config_file = File.join(Rails.root,'config','github.yml')
      raise "#{github_config_file} is missing!" unless File.exists? github_config_file
      github_config = YAML.load_file(github_config_file)[Rails.env].symbolize_keys
      @@config = {
        client_id: github_config[:client_id],
        secret: github_config[:secret],
        redirect_uri: github_config[:redirect_uri]
      }
    end
    @@config
  end
end
