require "pstore"

class ChadsMohawk
  PSTORE_FILENAME = "mohawk.pstore"
  Orientations = [:north, :west, :south, :east]
  TurnAt = [0,1,2,4,6,9,12,16,20,25,30,36,42,49,56,64,72,81,90,100,110,121,132,144,156,169,182,196,210,225,240,256,272,289,306,324,342,361,380,400,420,441,462,484,506,529,552,576,600,625,650,676,702,729,756,784,812,841,870,900,930,961,992,1024,1056,1089,1122,1156,1190,1225,1260,1296,1332,1369,1406,1444,1482,1521,1560]


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
  end

  def self.win?(coordinates)
    store = PStore.new(PSTORE_FILENAME)
    winning_space = store.transaction { store[:winning_space] }
    coordinates == winning_space
  end

  def self.rotate_orientation
    idx = Orientations.index(self.orientation)
    idx = (idx == Orientations.length - 1) ? 0 : idx+1
    self.orientation = Orientations[idx]
  end

  def self.should_rotate?
    TurnAt.include?(self.move_count)
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
