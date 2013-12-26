class UserMailer < ActionMailer::Base  
  default from: "gaoweihaomarui@gmail.com"  
  
  def send_mail(params={:subject => 'fdsfsdfdsf',   
          :to => "wind23real@126.com",   
          :from => 'gaoweihaomarui@gmail.com',   
          :date => Time.now , 
          :body => "dfdsf"})  
    @url  = 'http://example.com/login'  
    mail(params)  
  end   
end
