class Repository < ActiveRecord::Base

  TAGS = ['bytesize', 'easy', 'medium', 'hard']
  
  has_many :languages
  has_many :issues

  serialize :meta_data
  
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :owner

  acts_as_taggable
  
  def issues_url(label)
    "https://github.com/api/v2/json/issues/list/#{owner}/#{name}/label/#{label}"
  end

  def owner_url
    "http://github.com/#{owner}"
  end
  
  def populate_issues
    TAGS.each do |label|
      response = JSON.parse(Curl::Easy.perform(issues_url(label)).body_str)

      if response["issues"]
        response["issues"].each do |i|
          labels = i.delete "labels"

          new_issue = Issue.build(i)
          self.issues << new_issue

          labels.each do |name|
            new_issue.labels << Label.find_or_create_by_name(:name => name)
          end
        end
      end
    end

    save
  end

  def labeled_issues
    populate_issues if self.issues.empty?

    issues_hash = {}

    TAGS.each do |label|
      clause = ["issues.repository_id = (?) AND labels.name LIKE (?)", "#{self.id}", "%#{label}%"]
      issues_hash[label] = Issue.includes(:labels).where(clause)
    end

    issues_hash
  end
  
  def commits
    # TODO: FIXME
    #github.commits
  end
  
  def needs
    metadata.needs
  end
  
  def categories
    metadata.categories
  end
  
  def desired_roles
    roles = metadata.needs[:roles]
    validate_roles(roles)
  end
  
  def mentions
    metadata.mentions
  end
  
  def long_description
    metadata.long_description
  end
  
  def self.from_github_to_domain(github_repo)
    repository              = Repository.new
    repository.url          = github_repo.url
    repository.homepage     = github_repo.homepage
    repository.watchers     = github_repo.watchers
    repository.forks        = github_repo.forks
    repository.fork         = github_repo.fork
    repository.private      = github_repo.private
    repository.open_issues  = github_repo.open_issues
    repository.owner        = github_repo.owner.login
    repository.description  = github_repo.description
    repository.name         = github_repo.name
    repository.source       = "" #TODO: fixme, octopi does not support source
    repository.parent       = "" #TODO: fixme, octopi does not support parent

    # pushed_at
    # private
    # created_at # this is diff from this table's created_at
    # has_wiki
    # has_downloads
    # has_issues
    github_repo.languages.each do |k,v|
      repository.languages << Language.new({name: k, bytes: v})
    end

    repository
  end

  def self.find_or_import(owner, name)
    repository = Repository.where(owner: owner, name: name).first

    if repository.nil?
      begin
        # TODO: should do some error checking here
        repository = from_github_to_domain github_repository(owner, name)
        repository.save
      rescue Octopi::NotFound => e
        raise ActiveRecord::RecordNotFound
      end
    end
    repository
  end
  
  def metadata
    if !self.meta_data
      raw = Curl::Easy.perform("https://github.com/#{owner}/#{name}/raw/master/githacking.yml")
      if raw.header_str =~ /200/
        data = YAML::load(raw.body_str)
        self.meta_data = Metadata.new data
        save
      end
    end

    self.meta_data
  end

  private

  def github_repository
    @github_repo ||= Repository.github_repository self.owner, self.name
  end

  def self.github_repository owner, name
    Octopi::User.find(owner).repository(name)
  end

  #TODO: Move into Metadata::Role, with ActiveModel::Errors support, perhaps?
  def validate_roles(roles)
    roles.each do |role|
      raise "Missing required attribute" if role.name.nil? 
    end
    roles
  end

  public
  
  class Metadata
    attr_reader :long_description, :categories, :needs, :mentions
    def initialize data
      @long_description = data['long_description']
      @categories = data['categories']
      roles = Role.build(data['needs']['roles'])
      @needs = {roles: roles}
      @mentions = data['mentions']
    end

    def to_file
      file = Tempfile.new("githacking.yml")
      file.puts self.to_yaml
      file.flush
      file
    end

    class Role
      attr_reader :name, :language, :description
      
      def self.build data
        return data.collect { |datum| Role.new(datum) } if data.is_a? Array
        return [Role.new(data)]
      end

      def initialize data
        @name = data['role']
        @language = data['language']
        @description = data['description']
      end
    end
  end
end
