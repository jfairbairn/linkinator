require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation
  
  attr_accessor :tmp_url

  after_create do |user|
    msg =  <<-EOF

Hello,

I've just created a Linkinator account for you! 

The Linkinator is a place to share links, comments and discussions with
your workmates. Wondering whether to clog up everyone's inbox with that
fleetingly awesome YouTube movie? Wanting to start a discussion thread
about anything at all?
Wonder no more! Linkinate it and share the love.

Anyway, enough chat. Your username is #{user.login} and your password is
#{user.password} .

You can get to the Linkinator at #{user.tmp_url}.

Enjoy!

The Linkinator

EOF
    user.send_msg("Welcome to Linkinator!",msg)
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  
  has_many :posts, :order => 'created_at desc'
  
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def send_msg(subject, msg, url=nil)
    Notification.deliver_notification(self.email, subject, :message => msg)
  end
  
  def send_posts(posts)
    subject = posts.size == 1 ? "#{posts[0].original_post_id} #{posts[0].title}" : "[links] Recent posts from Linkinator"
    Notification.deliver_notification(self.email, subject, :messages => posts)
  end
  

  protected
    


end
