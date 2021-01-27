Rails.application.configure do
  config.lograge.enabled = true
  # add time to lograge
  config.lograge.custom_options = lambda do |event|
    { time: Time.now }
  end

  config.lograge.custom_payload do |controller|
    {
      host: controller.request.host,
      user_id: controller.current_user.try(:id)
    }
  end

  config.lograge.ignore_actions = ['SearchController#home', 'SearchController#requests']
end
