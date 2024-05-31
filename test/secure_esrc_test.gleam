import gleam/io
import gleam/option.{None, Some}
import gleam/result

import gleeunit
import gleeunit/should

import badge.{Alice, Bob, Eve}
import command.{OpenPortal}
import secure_esrc as secure

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

pub fn when_2_people_inside_a_third_can_just_enter_test() {
  let zone = secure.new()
  let assert #(None, zone) = secure.scan_in(zone, Alice)
  let assert #(Some(OpenPortal), zone) = secure.scan_in(zone, Bob)
  let zone = secure.notify_people_entered(zone, 2)
  let assert #(Some(OpenPortal), zone) = secure.scan_in(zone, Eve)
  let zone = secure.notify_people_entered(zone, 1)

  secure.number_inside(zone)
  |> should.equal(3)
}
