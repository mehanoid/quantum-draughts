# frozen_string_literal: true

require Rails.root.join('lib/performance_test/move.rb')

namespace :performance_test do
  task bench: :environment do
    require 'benchmark/ips'
    move_test = PerformanceTest::Move.new

    Benchmark.ips do |x|
      x.config(time: 10, warmup: 2)

      x.report('possible moves') do |iterations|
        iterations.times { move_test.possible_moves }
      end

      x.report('move') do |iterations|
        iterations.times { move_test.move }
      end
    end
  end

  task profile: :environment do
    move_test = PerformanceTest::Move.new

    Profiler.profile('possible_moves') do
      move_test.possible_moves
    end

    Profiler.profile('move') do
      move_test.move
    end
  end
end
