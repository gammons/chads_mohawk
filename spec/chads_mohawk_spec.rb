require_relative '../lib/chads_mohawk.rb'
require 'pry'

describe ChadsMohawk do
  it "is sane" do
    ChadsMohawk
  end

  describe "starting the game" do
    it "starts at (0,0)" do
      ChadsMohawk.start
      ChadsMohawk.position.should eql [0,0]
    end

    it "resets the winning space" do
      ChadsMohawk.should_receive(:reset_winning_space)
      ChadsMohawk.start
    end

    it "starts with a northward orientation" do
      ChadsMohawk.start
      ChadsMohawk.orientation.should eql :north
    end
  end

  describe ".rotate_orientation" do
    it "sets the next orientation" do
      ChadsMohawk.orientation = :north
      expect { ChadsMohawk.rotate_orientation }.to change { ChadsMohawk.orientation }.to :west
      expect { ChadsMohawk.rotate_orientation }.to change { ChadsMohawk.orientation }.to :south
      expect { ChadsMohawk.rotate_orientation }.to change { ChadsMohawk.orientation }.to :east
      expect { ChadsMohawk.rotate_orientation }.to change { ChadsMohawk.orientation }.to :north
    end
  end

  describe "moving around" do
    describe "the initial move" do
      it "goes left" do
        ChadsMohawk.start
        ChadsMohawk.move
        ChadsMohawk.position.should eql [-1,0]
      end

      it "sets the orientation to west" do
        ChadsMohawk.start
        ChadsMohawk.move
        ChadsMohawk.orientation.should eql :west
      end
    end

    describe "the second move" do
      it "sets the orientation to south" do
        ChadsMohawk.start
        2.times { ChadsMohawk.move }
        ChadsMohawk.orientation.should eql :south
      end

      it "moves to the next space" do
        ChadsMohawk.start
        2.times { ChadsMohawk.move }
        ChadsMohawk.position.should eql [-1,-1]
      end
    end

    describe "the fourth move" do
      it "sets the orientation to east" do
        ChadsMohawk.start
        4.times { ChadsMohawk.move }
        ChadsMohawk.orientation.should eql :east
      end

      it "moves to the next space" do
        ChadsMohawk.start
        4.times { ChadsMohawk.move }
        ChadsMohawk.position.should eql [1,-1]
      end
    end

    describe "the seventh move" do
      it "sets the orientation to west" do
        ChadsMohawk.start
        7.times { ChadsMohawk.move }
        ChadsMohawk.orientation.should eql :west
      end

      it "moves to the next space" do
        ChadsMohawk.start
        7.times { ChadsMohawk.move }
        ChadsMohawk.position.should eql [0,1]
      end
    end
  end

end

describe ChadsMohawk, "winning" do
  context "when the winning spot is (0,0)" do
    it "wins in zero moves" do
      ChadsMohawk.stub(:win?).and_return(false)
      ChadsMohawk.stub(:win?).with([0,0]).and_return(true)
      ChadsMohawk.play!.should eql 0
    end
  end

  context "when the winning spot is (1,-1)" do
    it "wins in four moves" do
      ChadsMohawk.stub(:win?).and_return(false)
      ChadsMohawk.stub(:win?).with([1,-1]).and_return(true)
      ChadsMohawk.play!.should eql 4
    end
  end

  context "when the winning spot is (20, -20)" do
    it "wins in 1600 moves" do
      ChadsMohawk.stub(:win?).and_return(false)
      ChadsMohawk.stub(:win?).with([20,-20]).and_return(true)
      ChadsMohawk.play!.should eql 1600
    end
  end

  context "when the winning spot is (-20, 20)" do
    it "wins in 1680 moves" do
      ChadsMohawk.stub(:win?).and_return(false)
      ChadsMohawk.stub(:win?).with([-20,20]).and_return(true)
      ChadsMohawk.play!.should eql 1680 #WTF?
    end
  end
end
