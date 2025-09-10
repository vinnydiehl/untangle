SCENES = %w[game].freeze

%w[constants untangle].each { |f| require "app/untangle/#{f}.rb" }

%w[scenes render].each { |dir| SCENES.each { |f| require "app/untangle/#{dir}/#{f}.rb" } }

def tick(args)
  args.state.game ||= UntangleGame.new(args)
  args.state.game.tick
end
