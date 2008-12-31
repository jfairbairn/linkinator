class Post < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :urls
  belongs_to :in_reply_to, :class_name => "Post"
  has_many :replies, :class_name => "Post", :foreign_key => "in_reply_to_id", :dependent => :nullify

  before_save do |post|
    post.update_urls!
  end
  
  HTTP_URL_REGEX =  /(\s|^)(https?:\/\/[\w\-_\.\/\+%]+(\?[\w\-_\.\/\+%=\&]+)?)(\s|$)/
  
  validates_presence_of :title

  def update_urls!
    new_urls = []
    old_urls = self.urls.map{|i|i.url}
    self.content.scan(HTTP_URL_REGEX) do |match|
      new_urls << match[1] if match and match[1]
    end
    self.urls.reject!{|i|! (new_urls.member?(i.url))}
    new_urls.each{|i|self.urls << Url.find_or_create(i) unless old_urls.member?(i)}
  end
  
end
