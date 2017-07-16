if defined?(JazzFingers)
  JazzFingers.configure do |config|
    config.colored_prompt = true
    config.awesome_print = false
  end

  require 'jazz_fingers/setup'
end
