import gleam/io
import gleam/list
import gleam/option
import gleam/result

import badge.{type Badge, Alice, Bob, Eve}
import command.{type Command, OpenPortal}

pub opaque type SecureZone {
  SecureZone(
    badges_to_enter: List(Badge),
    count: Int,
    badges_inside: List(Badge),
    badges_trying_to_leave: List(Badge),
  )
}

pub fn new() -> SecureZone {
  SecureZone(
    badges_to_enter: [],
    badges_inside: [],
    count: 0,
    badges_trying_to_leave: [],
  )
}

pub fn scan_in(
  zone: SecureZone,
  badge: Badge,
) -> #(option.Option(Command), SecureZone) {
  case zone.badges_to_enter {
    [] -> #(option.None, SecureZone(..zone, badges_to_enter: [badge]))
    [b] if b != badge -> #(
      option.Some(OpenPortal),
      SecureZone(..zone, badges_to_enter: [b, ..zone.badges_to_enter]),
    )
    [b] if b == badge -> #(option.None, zone)
    _ -> panic as "Should never happen"
  }
}

pub fn notify_people_entered(
  zone: SecureZone,
  number_entered: Int,
) -> SecureZone {
  SecureZone(
    ..zone,
    count: number_entered + zone.count,
    badges_to_enter: [],
    badges_inside: list.append(zone.badges_inside, zone.badges_to_enter),
  )
}

// pub fn scan_out(zone: SecureZone, badge: Badge) -> SecureZone {
//   case zone.badges_inside {
//     [] -> zone
//     badges -> {
//       use x <- result.try(list.pop(badges, fn(x) { x == badge }))
//     }
//     _ -> panic as "Should never happen on scanning out"
//   }
//   zone
// }

pub fn number_inside(zone: SecureZone) -> Int {
  zone.count
}
