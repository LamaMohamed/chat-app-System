Sidekiq.configure_server do |config|
    config.redis = { url: 'redis://localhost:6379/0' }
  
    schedule_file = "config/sidekiq.yml"
  
    if File.exists?(schedule_file) && Sidekiq.server?
      Sidekiq::Scheduler.reload_schedule!
    end
  end
  
  Sidekiq.configure_client do |config|
    config.redis = { url: 'redis://localhost:6379/0' }
  end