SCENES = %w[main_menu game pause_menu].freeze

require "lib/union_find/union_find.rb"
%w[hash string symbol].each { |f| require "lib/core_ext/#{f}.rb" }

%w[colors constants generate input
   menu movement untangle].each { |f| require "app/untangle/#{f}.rb" }

%w[scenes render].each { |dir| SCENES.each { |f| require "app/untangle/#{dir}/#{f}.rb" } }

require "app/untangle/render/shared.rb"

def tick(args)
  args.state.game ||= UntangleGame.new(args)
  args.state.game.tick
end
