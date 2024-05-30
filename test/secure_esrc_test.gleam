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
