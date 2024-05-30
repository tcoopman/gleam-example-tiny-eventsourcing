import gleam/io

pub opaque type SecureZone {
  SecureZone(badges: List(Badge), count: Int)
}

pub type Badge {
  Alice
  Bob
  Eve
}

pub fn new() -> SecureZone {
  SecureZone(badges: [], count: 0)
}

pub fn scan_in(zone: SecureZone, badge: Badge) -> SecureZone {
  case zone.badges {
    [] -> SecureZone(..zone, badges: [badge])
    [b] if b != badge -> SecureZone(badges: [], count: 2)
    [b] if b == badge -> zone
    _ -> panic as "Should never happen"
  }
}

pub fn scan_out(zone: SecureZone, badge: Badge) -> SecureZone {
  zone
}

pub fn number_inside(zone: SecureZone) -> Int {
  zone.count
}
