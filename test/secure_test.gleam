import gleeunit
import gleeunit/should

import secure.{Alice, Bob, Eve}

pub fn main() {
  gleeunit.main()
}

pub fn no_one_inside_test() {
  secure.new()
  |> secure.scan_in(Alice)
  |> secure.number_inside
  |> should.equal(0)
}

pub fn scanning_twice_does_not_put_you_inside_test() {
  secure.new()
  |> secure.scan_in(Alice)
  |> secure.scan_in(Alice)
  |> secure.number_inside
  |> should.equal(0)
}

pub fn two_people_inside_test() {
  secure.new()
  |> secure.scan_in(Alice)
  |> secure.scan_in(Bob)
  |> secure.number_inside
  |> should.equal(2)
}

pub fn scanning_twice_is_ok_test() {
  secure.new()
  |> secure.scan_in(Alice)
  |> secure.scan_in(Alice)
  |> secure.scan_in(Bob)
  |> secure.number_inside
  |> should.equal(2)
}

pub fn scanning_out_needs_2_scans_test() {
  secure.new()
  |> secure.scan_in(Alice)
  |> secure.scan_in(Bob)
  |> secure.scan_out(Bob)
  |> secure.number_inside
  |> should.equal(2)
}

pub fn scanning_both_out_test() {
  secure.new()
  |> secure.scan_in(Alice)
  |> secure.scan_in(Bob)
  |> secure.scan_out(Bob)
  |> secure.scan_in(Alice)
  |> secure.number_inside
  |> should.equal(0)
}

pub fn scanning_out_someone_who_is_not_inside() {
  secure.new()
  |> secure.scan_in(Alice)
  |> secure.scan_in(Bob)
  |> secure.scan_out(Bob)
  |> secure.scan_in(Eve)
  |> secure.number_inside
  |> should.equal(2)
}
