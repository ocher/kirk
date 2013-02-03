run lambda { |e|
  body = ""

  require 'active_support'
  body << "required ActiveSupport\n"

  begin
    require 'rspec'
    body << "successfully loaded rspec\n"
  rescue LoadError
    body << "failed to load rspec\n"
  end

  [ 200, { 'Content-Type' => 'text/plain' }, [ body ] ]
}
