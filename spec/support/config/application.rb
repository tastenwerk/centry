Centry::configure do |config|

  config.action_mailer.default_options = { from: 'no-reply@example.com' }
  config.action_mailer.delivery_method = :test
  config.action_mailer.raise_delivery_errors = false
  
end