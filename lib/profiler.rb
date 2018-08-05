# frozen_string_literal: true

module Profiler
  def self.profile(name = 'profile')
    profile = RubyProf::Profile.new
    profile.exclude_common_methods!
    profile.start
    yield
    result = profile.stop
    RubyProf::CallTreePrinter.new(result).print(path: Rails.root.join('reports'), profile: name)
  end
end
