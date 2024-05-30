pub opaque type MarsRover {
  Rover(position: Position, direction: Direction)
}

pub type Position {
  Position(x: Int, y: Int)
}

pub type Direction {
  North
  East
  South
  West
}

pub type Command {
  Forward
}

pub fn new(position: Position, direction: Direction) -> MarsRover {
  Rover(position, direction)
}

pub fn state(rover: MarsRover) -> #(Position, Direction) {
  #(rover.position, rover.direction)
}

pub fn execute(rover: MarsRover, _commands: List(Command)) -> MarsRover {
  rover
}
