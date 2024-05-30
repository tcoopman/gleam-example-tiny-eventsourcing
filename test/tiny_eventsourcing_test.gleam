import gleeunit
import gleeunit/should

import tiny_eventsourcing as rover
import tiny_eventsourcing.{Backward, East, Forward, Left, North, Position, Right}

pub fn main() {
  gleeunit.main()
}

pub fn new_rover_test() {
  rover.new(Position(0, 0), North)
  |> rover.state()
  |> should.equal(#(Position(0, 0), North))
}

pub fn move_one_forward_test() {
  rover.new(Position(0, 0), North)
  |> rover.execute([Forward])
  |> rover.state()
  |> should.equal(#(Position(0, 1), North))
}

pub fn move_x_forward_test() {
  rover.new(Position(0, 0), North)
  |> rover.execute([Forward, Forward, Forward])
  |> rover.state()
  |> should.equal(#(Position(0, 3), North))
}

pub fn move_multiple_directions_test() {
  rover.new(Position(0, 0), North)
  |> rover.execute([Forward, Backward, Left, Right])
  |> rover.state()
  |> should.equal(#(Position(0, 0), North))
}

pub fn complex_move_test() {
  rover.new(Position(0, 0), North)
  |> rover.execute([Forward, Right, Forward, Forward, Left, Backward, Right])
  |> rover.state()
  |> should.equal(#(Position(2, 0), East))
}
