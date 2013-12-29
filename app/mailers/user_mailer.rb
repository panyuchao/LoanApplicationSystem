class UserMailer < ActionMailer::Base  
  default from: "test_admin001@163.com"  
  
  def accept_email(params) 
      @subject = params[:subject]
      @to = params[:to]
      @from = params[:from]
      @sent_on = Time.now
      @body = params[:body]
      @headers = {}
      mail(to: @to,
         subject: @subject,
	 from: @from,
	 date: @sent_on,
         template_path: 'user_mailer',
         template_name: 'accept')
  end   

  def reject_email(params) 
      @subject = params[:subject]
      @to = params[:to]
      @from = params[:from]
      @sent_on = Time.now
      @body = params[:body]
      @headers = {}
      mail(to: @to,
         subject: @subject,
	 from: @from,
	 date: @sent_on,
         template_path: 'user_mailer',
         template_name: 'reject')
  end  

  def new_user_email(params) 
      @subject = params[:subject]
      @to = params[:to]
      @from = params[:from]
      @sent_on = Time.now
      @body = params[:body]
      @headers = {}
      mail(to: @to,
         subject: @subject,
	 from: @from,
	 date: @sent_on,
         template_path: 'user_mailer',
         template_name: 'new_user')
  end  

  def forget_password_email(params) 
      @subject = params[:subject]
      @to = params[:to]
      @from = params[:from]
      @sent_on = Time.now
      @body = params[:body]
      @headers = {}
      mail(to: @to,
         subject: @subject,
	 from: @from,
	 date: @sent_on,
         template_path: 'user_mailer',
         template_name: 'forget_password')
  end 
end
