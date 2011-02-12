module Github
  def self.config
    github_config_file = File.join(Rails.root,'config','github.yml')
    raise "#{github_config_file} is missing!" unless File.exists? github_config_file

    @@config ||= YAML.load_file(github_config_file)[Rails.env]
  end
end
