class Repository < ActiveRecord::Base

  TAGS = ['bytesize', 'easy', 'medium', 'hard']
  
  has_many :languages

  serialize :meta_data
  
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :owner

  acts_as_taggable
  
  def owner_url
    "http://github.com/#{owner}"
  end
  
  def issues
    @issues = {}
    TAGS.each do |tag|
      github.issues.reject { |issue| !issue.labels.include?(tag) }.each do |issue|
        @issues[tag] ||= []
        @issues[tag] << issue
      end
    end
    return @issues
  rescue 
  {}
  end
  
  def commits
    # TODO: FIXME
    #github.commits
  end
  
  def needs
    metadata['needs']
  rescue 
  []
  end
  
  def categories
    metadata['categories']
  rescue 
  []
  end
  
  def desired_roles
    metadata['needs']['roles']
  rescue 
  []
  end
  
  def desired_skills
    metadata['needs']['skills']
  rescue 
  []
  end
  
  def mentions
    metadata['mentions']
  rescue 
  []
  end
  
  def long_description
    metadata['long_description']
  rescue 
  nil
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
      repository.languages << Language.new({:name => k, :bytes => v})
    end

    repository
  end

  def self.find_or_import(owner, name)
    repository = Repository.where(url: "https://github.com/#{owner}/#{name}").first

    if repository.nil?
      begin
        grepo = Octopi::User.find(owner).repository(name)

        # TODO: should do some error checking here
        repository = from_github_to_domain(grepo)
        repository.save

      rescue Octopi::NotFound => e
        raise ActiveRecord::RecordNotFound
      end
    end
    repository
  end
  
  def metadata
    if !self.meta_data
      raw = Curl::Easy.perform("https://github.com/#{owner}/#{name}/raw/master/githacking.yaml")
      if raw.header_str =~ /200/
        y = YAML::load(raw.body_str)
        self.meta_data = y
        save
      end
    end

    self.meta_data
  end
  

end
