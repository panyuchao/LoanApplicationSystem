class UserMailer < ActionMailer::Base  
  default from: "test_admin001@163.com"  
  
  def send_mail(params = {})  
    @url  = 'http://example.com/login'  
    mail( :subject => 'fdsfsdfdsf',   
          :to => "wind23real@126.com",   
          :from => 'test_admin001@163.com',   
          :date => Time.now  
        )   
  end   
end
