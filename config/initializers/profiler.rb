require 'rack-mini-profiler'

Rack::MiniProfilerRails.initialize!(Rails.application)


if Rails.env.production? or Rails.env.staging?
  Rails.application.middleware.delete(Rack::MiniProfiler)
  Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler)
end

Rack::MiniProfiler.config.position = 'right'
Rack::MiniProfiler.config.start_hidden = true
