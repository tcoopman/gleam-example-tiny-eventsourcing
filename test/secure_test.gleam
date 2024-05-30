import gleam/io
import gleam/option.{None, Some}
import gleam/result

import gleeunit
import gleeunit/should

import badge.{Alice, Bob, Eve}
import command.{OpenPortal}
import secure

pub fn main() {
  gleeunit.main()
}

pub fn no_one_inside_test() {
  let zone = secure.new()
  let assert #(None, zone) = secure.scan_in(zone, Alice)

  secure.number_inside(zone)
  |> should.equal(0)
}

pub fn scanning_same_person_twice_test() {
  let zone = secure.new()
  let assert #(None, zone) = secure.scan_in(zone, Alice)
  let assert #(None, zone) = secure.scan_in(zone, Alice)

  secure.number_inside(zone)
  |> should.equal(0)
}

pub fn scanning_the_second_person_in_should_open_the_portal_test() {
  let zone = secure.new()
  let assert #(None, zone) = secure.scan_in(zone, Alice)
  let assert #(Some(OpenPortal), zone) = secure.scan_in(zone, Bob)

  secure.number_inside(zone)
  |> should.equal(0)
}

pub fn after_confirming_access_2_people_inside_test() {
  let zone = secure.new()
  let assert #(None, zone) = secure.scan_in(zone, Alice)
  let assert #(Some(OpenPortal), zone) = secure.scan_in(zone, Bob)
  let zone = secure.notify_people_entered(zone, 2)

  secure.number_inside(zone)
  |> should.equal(2)
}
// pub fn no_one_inside_test() {
//   secure.new()
//   |> secure.scan_in(Alice)
//   |> secure.number_inside
//   |> should.equal(0)
// }

// pub fn scanning_twice_does_not_put_you_inside_test() {
//   secure.new()
//   |> secure.scan_in(Alice)
//   |> secure.scan_in(Alice)
//   |> secure.number_inside
//   |> should.equal(0)
// }

// pub fn two_people_inside_test() {
//   secure.new()
//   |> secure.scan_in(Alice)
//   |> secure.scan_in(Bob)
//   |> secure.scan_in(Bob)
//   |> secure.number_inside
//   |> should.equal(2)
// }

// pub fn scanning_twice_is_ok_test() {
//   secure.new()
//   |> secure.scan_in(Alice)
//   |> secure.scan_in(Alice)
//   |> secure.scan_in(Bob)
//   |> secure.number_inside
//   |> should.equal(2)
// }

// pub fn scanning_out_needs_2_scans_test() {
//   secure.new()
//   |> secure.scan_in(Alice)
//   |> secure.scan_in(Bob)
//   |> secure.scan_out(Bob)
//   |> secure.number_inside
//   |> should.equal(2)
// }

// pub fn scanning_both_out_test() {
//   secure.new()
//   |> secure.scan_in(Alice)
//   |> secure.scan_in(Bob)
//   |> secure.scan_out(Bob)
//   |> secure.scan_in(Alice)
//   |> secure.number_inside
//   |> should.equal(0)
// }

// pub fn scanning_out_someone_who_is_not_inside() {
//   secure.new()
//   |> secure.scan_in(Alice)
//   |> secure.scan_in(Bob)
//   |> secure.scan_out(Bob)
//   |> secure.scan_in(Eve)
//   |> secure.number_inside
//   |> should.equal(2)
// }
