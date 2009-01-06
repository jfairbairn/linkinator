class Notification < ActionMailer::Base
  def notification(recipient, thesubject, args)
    recipients recipient
    from 'Linkinator <noreply@linkinator>'
    subject thesubject
    body args
  end
  

end
