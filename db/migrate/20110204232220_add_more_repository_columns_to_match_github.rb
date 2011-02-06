class AddMoreRepositoryColumnsToMatchGithub < ActiveRecord::Migration
  def self.up
    add_column :repositories, :name,        :string
    add_column :repositories, :owner,       :string
    add_column :repositories, :description, :string
    add_column :repositories, :pushed_at,   :datetime
    add_column :repositories, :url,         :string,    :null    => false
    add_column :repositories, :private,     :boolean,   :default => false
    add_column :repositories, :has_wiki,    :boolean,   :default => false
    add_column :repositories, :homepage,    :string,    :null => true
    add_column :repositories, :watchers,    :integer,   :null => false, :default => 0
    add_column :repositories, :forks,       :integer,   :null => false, :default => 0
    add_column :repositories, :fork,        :boolean,   :null => false, :default => false
    add_column :repositories, :open_issues, :integer,   :null => false, :default => 0
    add_column :repositories, :has_issues,  :boolean ,  :null => false, :default => false
    add_column :repositories, :has_downloads, :boolean, :null => false, :default => false
    add_column :repositories, :source,      :string,    :null => false
    add_column :repositories, :parent,      :string,    :null => false
  end

  def self.down
    remove_column :repositories, :url
    remove_column :repositories, :name
    remove_column :repositories, :owner
    remove_column :repositories, :description
    remove_column :repositories, :homepage
    remove_column :repositories, :watchers
    remove_column :repositories, :forks
    remove_column :repositories, :open_issues
    remove_column :repositories, :has_issues
    remove_column :repositories, :source
    remove_column :repositories, :parent
    remove_column :repositories, :has_downloads
    remove_column :repositories, :pushed_at
    remove_column :repositories, :private
    remove_column :repositories, :has_wiki
    add_column    :repositories, :fork
  end
end
