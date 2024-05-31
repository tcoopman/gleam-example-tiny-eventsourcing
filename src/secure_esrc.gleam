import gleam/list
import gleam/option

import badge.{type Badge}
import command.{type Command, OpenPortal}

pub opaque type Event {
  BadgeRead(Badge)
  SecondBadgeRead(Badge)
  PersonEntered(Badge)
  AccessGranted(Badge)
}

pub opaque type SecureZone {
  SecureZone(events: List(Event))
}

type State {
  State(
    badges_waiting_to_enter: List(Badge),
    people_inside: List(Badge),
    waiting_for_portal: Bool,
  )
}

const initial_state = State(
  badges_waiting_to_enter: [],
  people_inside: [],
  waiting_for_portal: False,
)

pub fn new() -> SecureZone {
  SecureZone(events: [])
}

pub fn scan_in(
  zone: SecureZone,
  badge: Badge,
) -> #(option.Option(Command), SecureZone) {
  let #(zone, state) = do(zone, do_scan_in(_, badge))
  case state.waiting_for_portal {
    True -> #(option.Some(OpenPortal), zone)
    False -> #(option.None, zone)
  }
}

fn do(zone: SecureZone, doer: fn(State) -> List(Event)) -> #(SecureZone, State) {
  let events =
    zone.events
    |> apply
    |> doer

  let new_events = list.append(zone.events, events)
  let new_state = apply(new_events)
  #(SecureZone(events: new_events), new_state)
}

pub fn notify_people_entered(zone: SecureZone, count: Int) -> SecureZone {
  let #(zone, _) = do(zone, notify_people_entered2(_, count))
  zone
}

fn do_scan_in(state: State, badge: Badge) -> List(Event) {
  let number_of_people_inside = list.length(state.people_inside)
  case number_of_people_inside, state.badges_waiting_to_enter {
    x, [] if x >= 2 -> [BadgeRead(badge), AccessGranted(badge)]
    _, [] -> [BadgeRead(badge)]
    _, [b] if b != badge -> [SecondBadgeRead(badge), AccessGranted(badge)]
    _, [b] if b == badge -> []
    _, _ -> panic
  }
}

fn notify_people_entered2(state: State, count: Int) -> List(Event) {
  case state.badges_waiting_to_enter, count {
    [badge1, badge2], 2 -> [PersonEntered(badge1), PersonEntered(badge2)]
    [badge], 1 -> [PersonEntered(badge)]
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
      AccessGranted(_badge) -> State(..state, waiting_for_portal: True)
      PersonEntered(badge) ->
        State(
          waiting_for_portal: False,
          badges_waiting_to_enter: [],
          people_inside: [badge, ..state.people_inside],
        )
    }
  })
}

pub fn number_inside(zone: SecureZone) -> Int {
  let state = apply(zone.events)
  list.length(state.people_inside)
}
