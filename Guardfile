
ignore %r{test/integration/.+_test\.rb$}


guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
end


guard :minitest, spring: "bin/rails test", all_on_start: false do


  watch('test/test_helper.rb')  { "test" }
  watch(%r{test/factories/(.+)\.rb})  { "test" }

  # Rails 4
  watch(%r{^app/(.+)\.rb})                               { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/application_controller\.rb}) { 'test/controllers' }
  watch(%r{^app/controllers/(.+)_controller\.rb})        { |m| "test/controllers/#{m[1]}_test.rb" }
  watch(%r{^app/views/(.+)_mailer/.+})                   { |m| "test/mailers/#{m[1]}_mailer_test.rb" }
  watch(%r{^app/models/(.+)\.rb})                        { |m| "test/models/#{m[1]}_test.rb" }
  watch(%r{^app/jobs/(.+)\.rb})                        { |m| "test/jobs/#{m[1]}_test.rb" }
  watch(%r{^lib/(.+)\.rb})                               { |m| "test/lib/#{m[1]}_test.rb" }
  watch(%r{^test/.+_test\.rb})
  watch(%r{^test/test_helper\.rb}) { 'test' }



end
