BEST_TIMES_FILE = "save_data/best_times"

# Difficulty levels, based on the following factors:
#
#  - :node_count is the number of nodes in the graph
#  - :max_degree is the maximum number of edges that can be connected
#                to a given node during generation
#  - :groups is the number of separate graphs which are generated
DIFFICULTY = {
  easy: {
    node_count: 10,
    max_degree: 4,
    groups: 1,
  },
  intermediate: {
    node_count: 20,
    max_degree: 4,
    groups: 1,
  },
  hard: {
    node_count: 20,
    max_degree: 5,
    groups: 1,
  },
  expert: {
    node_count: 25,
    max_degree: 6,
    groups: 1,
  },
  double_trouble: {
    node_count: 12,
    max_degree: 4,
    groups: 2,
  },
}

NODE_RADIUS = 16
NODE_DIAMETER = NODE_RADIUS * 2

# Radius of the circle of nodes centered in the screen
# after shuffling
NODE_CIRCLE_RADIUS = 300

LINE_THICKNESS = 4

START_ANIMATION_DURATION = 0.3.seconds
RETURN_ANIMATION_DURATION = 0.1.seconds

TIMER_SIZE = 15
TIME_TO_BEAT_SIZE = 2
NEW_BEST_TIME_MESSAGE_SIZE = 8
SOLVED_MESSAGE_SIZE = 1
TEXT_PADDING = 10
