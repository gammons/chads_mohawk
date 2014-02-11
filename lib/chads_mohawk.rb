require "pstore"

class ChadsMohawk
  PSTORE_FILENAME = "mohawk.pstore"
  Orientations = [:north, :west, :south, :east]


  class << self
    attr_accessor :position
    attr_accessor :orientation
    attr_accessor :move_count
  end

  def self.series
    arr = 10.times.map { play! }
    arr.reduce(:+).to_f / arr.size
  end

  def self.play!
    start
    while not win?(self.position)
      move
    end

    self.move_count
  end

  def self.start
    reset_winning_space
    reset_position
    reset_orientation
    reset_move_count
  end

  def self.move
    rotate_orientation if should_rotate?

    case orientation
    when :west
      self.position[0] -= 1
    when :south
      self.position[1] -= 1
    when :east
      self.position[0] += 1
    when :north
      self.position[1] += 1
    end
    self.move_count += 1
    #$stdout << "move count: #{self.move_count}, position = #{self.position.inspect}, orientation = #{self.orientation}, winner = #{self.winning_space.inspect}\n"
  end

  def self.win?(coordinates)
    store = PStore.new(PSTORE_FILENAME)
    winning_space = store.transaction { store[:winning_space] }
    coordinates == winning_space
  end

  def self.winning_space
    store = PStore.new(PSTORE_FILENAME)
    winning_space = store.transaction { store[:winning_space] }
  end

  def self.rotate_orientation
    idx = Orientations.index(self.orientation)
    idx = (idx == Orientations.length - 1) ? 0 : idx+1
    self.orientation = Orientations[idx]
  end

  def self.should_rotate?
    self.move_count == 0 ||
      self.move_count % Math.sqrt(self.move_count).ceil == 0
  end

  private


  def self.reset_position
    self.position = [0,0]
  end

  def self.reset_orientation
    self.orientation = :north
  end

  def self.reset_move_count
    self.move_count = 0
  end

  def self.reset_winning_space
    store = PStore.new(PSTORE_FILENAME)
    store.transaction { store[:winning_space] = [random_space, random_space] }
  end

  def self.random_space
    (-20..20).to_a.sample
  end
end
