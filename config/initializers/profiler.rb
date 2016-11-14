require 'rack-mini-profiler'

Rack::MiniProfilerRails.initialize!(Rails.application)

Rack::MiniProfiler.config.position = 'right'
Rack::MiniProfiler.config.start_hidden = false
