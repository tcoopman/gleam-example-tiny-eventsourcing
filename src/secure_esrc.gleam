import gleam/list
import gleam/option

import badge.{type Badge, Alice, Bob, Eve}
import command.{type Command, OpenPortal}

pub opaque type Event {
  BadgeRead(Badge)
  SecondBadgeRead(Badge)
  PeopleEntered(Badge, Badge)
}

pub opaque type SecureZone {
  SecureZone(events: List(Event))
}

type State {
  State(badges_waiting_to_enter: List(Badge), people_inside: List(Badge))
}

const initial_state = State(badges_waiting_to_enter: [], people_inside: [])

pub fn new() -> SecureZone {
  SecureZone(events: [])
}

pub fn scan_in(
  zone: SecureZone,
  badge: Badge,
) -> #(option.Option(Command), SecureZone) {
  let state = apply(zone.events)
  let events = scan_in2(state, badge)
  let zone = SecureZone(events: list.append(zone.events, events))
  case events {
    [SecondBadgeRead(_)] -> #(option.Some(OpenPortal), zone)
    _ -> #(option.None, zone)
  }
}

pub fn notify_people_entered(zone: SecureZone, count: Int) -> SecureZone {
  let state = apply(zone.events)
  let events = notify_people_entered2(state, count)
  SecureZone(events: list.append(zone.events, events))
}

fn scan_in2(state: State, badge: Badge) -> List(Event) {
  case state.badges_waiting_to_enter {
    [] -> [BadgeRead(badge)]
    [b] if b != badge -> [SecondBadgeRead(badge)]
    [b] if b == badge -> []
    _ -> panic
  }
}

fn notify_people_entered2(state: State, count: Int) -> List(Event) {
  case state.badges_waiting_to_enter, count {
    [badge1, badge2], 2 -> [PeopleEntered(badge1, badge2)]
    _, _ -> panic as "Invalid state here???"
  }
}

fn apply(history: List(Event)) -> State {
  list.fold(history, initial_state, fn(state, event) {
    case event {
      BadgeRead(badge) -> State(..state, badges_waiting_to_enter: [badge])
      SecondBadgeRead(badge) ->
        State(
          ..state,
          badges_waiting_to_enter: [badge, ..state.badges_waiting_to_enter],
        )
      PeopleEntered(badge1, badge2) ->
        State(badges_waiting_to_enter: [], people_inside: [badge1, badge2])
    }
  })
}

pub fn number_inside(zone: SecureZone) -> Int {
  let state = apply(zone.events)
  list.length(state.people_inside)
}
