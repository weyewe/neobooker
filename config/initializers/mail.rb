if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com'
  }
  ActionMailer::Base.delivery_method = :smtp
# elsif Rails.env.development?
#   ActionMailer::Base.smtp_settings = {
#     :address        => 'smtp.gmail.net',
#     :port           => '587',
#     :authentication => :plain,
#     :user_name      => 'bangjay.sm@gmail.com',
#     :password       => 'bangjay1234',
#     :domain         => 'heroku.com'
#   }
#   ActionMailer::Base.delivery_method = :smtp
end
# 
# # 
# # 
# # config.action_mailer.default_url_options = { host: "localhost", :port => 3000 }
# # config.action_mailer.raise_delivery_errors = true
# # config.action_mailer.delivery_method = :smtp
# # config.action_mailer.smtp_settings = {
# #   address: "smtp.gmail.com",
# #   port: 587,
# #   domain: "supermetal.com",
# #   authentication: "plain",
# #   enable_starttls_auto: true,
# #   user_name: 'bangjay.sm@gmail.com',
# #   password: 'bangjay1234'
# # }