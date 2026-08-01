class Level
  LEVELS = {
    "easy" => { label: "かんたん", finish_from_turn: 5 },
    "normal" => { label: "ふつう", finish_from_turn: 10 },
    "hard" => { label: "むずかしい", finish_from_turn: 15 },
  }.freeze

  DEFAULT = "normal"

  def self.valid?(level)
    LEVELS.key?(level)
  end

  def self.finish_from_turn(level)
    LEVELS.fetch(level, LEVELS[DEFAULT])[:finish_from_turn]
  end
end
