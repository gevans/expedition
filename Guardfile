guard 'bundler' do
  watch('Gemfile')
  watch(%r{\w+\.gemspec})
end

guard 'rspec', cmd: 'bundle exec rspec', all_on_start: true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})      { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')   { 'spec' }
  watch(%r{^lib/config/locales}) { 'spec/launchkey/errors' }
end

guard 'yard' do
  watch(%r{lib/.+\.rb})
end
