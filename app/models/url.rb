class Url < ActiveRecord::Base
  has_and_belongs_to_many :posts
  
  def self.find_or_create(url)
    find_by_url(url) or Url.create(:url=>url)
  end
  
  def self.find_by_url(url)
    find(:first, :conditions => ['url=?', url])
  end
end
