class UserMailer < ActionMailer::Base  
  default from: "test_admin001@163.com"  
  
  def send_mail(params={:subject => 'fdsfsdfdsf',   
          :to => "wind23real@126.com",   
          :from => 'test_admin001@163.com',   
          :date => Time.now , 
          :body => "dfdsf"})  
    @url  = 'http://example.com/login'  
    mail(params)  
  end   
end
