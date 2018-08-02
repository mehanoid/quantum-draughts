# frozen_string_literal: true

RSpec::Matchers.define :match_multiboard do |expected|
  match do |actual|
    actual_strings = actual.map(&:to_s)
    (actual_strings - expected).empty? && (expected - actual_strings).empty?
  end
  failure_message do |actual|
    <<~MESSAGE
      expected boards contained:
      #{expected.join("\n")}
      actual boards contained:
      #{actual.map(&:to_s).join("\n")}
    MESSAGE
  end
end
