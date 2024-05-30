import gleeunit
import gleeunit/should

import tiny_eventsourcing as rover
import tiny_eventsourcing.{Forward, North, Position}

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
  |> should.equal(#(Position(1, 0), North))
}
