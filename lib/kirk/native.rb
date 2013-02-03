require 'kirk/native.jar'

module Kirk
  Jetty # Trigger the jetty autoload

  module Native
    java_import "com.strobecorp.kirk.ApplicationConfig"
    java_import "com.strobecorp.kirk.HotDeployableApplication"
    java_import "com.strobecorp.kirk.RewindableInputStream"
  end
end
