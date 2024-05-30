import gleam/option

import badge.{type Badge, Alice, Bob, Eve}
import command.{type Command, OpenPortal}

pub opaque type Event {
  BadgeRead(Badge)
}

pub opaque type SecureZone {
  SecureZone(events: List(Event))
}

pub fn new() -> SecureZone {
  SecureZone(events: [])
}

pub fn scan_in(
  zone: SecureZone,
  badge: Badge,
) -> #(option.Option(Command), SecureZone) {
  #(option.None, zone)
}

pub fn number_inside(zone: SecureZone) -> Int {
  0
}
