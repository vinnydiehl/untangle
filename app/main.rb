SCENES = %w[game].freeze

require "lib/union_find/union_find.rb"

%w[constants generate input movement untangle].each { |f| require "app/untangle/#{f}.rb" }

%w[scenes render].each { |dir| SCENES.each { |f| require "app/untangle/#{dir}/#{f}.rb" } }

def tick(args)
  args.state.game ||= UntangleGame.new(args)
  args.state.game.tick
end
