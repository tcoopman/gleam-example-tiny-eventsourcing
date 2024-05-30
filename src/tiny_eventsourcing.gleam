import gleam/list

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
  Backward
  Left
  Right
}

pub fn new(position: Position, direction: Direction) -> MarsRover {
  Rover(position, direction)
}

pub fn state(rover: MarsRover) -> #(Position, Direction) {
  #(rover.position, rover.direction)
}

pub fn execute(rover: MarsRover, commands: List(Command)) -> MarsRover {
  list.fold(commands, rover, execute_one)
}

fn execute_one(rover: MarsRover, command: Command) -> MarsRover {
  case command {
    Forward -> move_forward(rover)
    Backward -> move_backward(rover)
    Left -> turn_left(rover)
    Right -> turn_right(rover)
  }
}

fn move_forward(rover: MarsRover) -> MarsRover {
  let new_position = case rover.direction {
    North -> Position(..rover.position, y: rover.position.y + 1)
    East -> Position(..rover.position, x: rover.position.x + 1)
    South -> Position(..rover.position, y: rover.position.y - 1)
    West -> Position(..rover.position, x: rover.position.x - 1)
  }
  Rover(..rover, position: new_position)
}

fn move_backward(rover: MarsRover) -> MarsRover {
  let new_position = case rover.direction {
    North -> Position(..rover.position, y: rover.position.y - 1)
    East -> Position(..rover.position, x: rover.position.x - 1)
    South -> Position(..rover.position, y: rover.position.y + 1)
    West -> Position(..rover.position, x: rover.position.x + 1)
  }
  Rover(..rover, position: new_position)
}

fn turn_left(rover: MarsRover) -> MarsRover {
  let new_direction = case rover.direction {
    North -> West
    West -> South
    South -> East
    East -> North
  }
  Rover(..rover, direction: new_direction)
}

fn turn_right(rover: MarsRover) -> MarsRover {
  let new_direction = case rover.direction {
    North -> East
    East -> South
    South -> West
    West -> North
  }
  Rover(..rover, direction: new_direction)
}
