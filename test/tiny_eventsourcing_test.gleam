import gleeunit
import gleeunit/should

import tiny_eventsourcing as rover
import tiny_eventsourcing.{North, Position}

pub fn main() {
  gleeunit.main()
}

pub fn new_rover_test() {
  rover.new(Position(0, 0), North)
  |> rover.state()
  |> should.equal(#(Position(0, 0), North))
}
