class UserMailer < ActionMailer::Base  
  default from: "test_admin001@163.com"  
  
  def send_mail(params)   
    mail(params)  
  end   
end
