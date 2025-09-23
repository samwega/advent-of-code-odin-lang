// I did the first 5 and skipped to this one to see if it got much harder. It was hard and it took me 8 attempts

package aoc

import "core:fmt"

COL :u64: 3075
ROW :u64: 2981
FIRST_NUM :u64: 20151125 
final:= FIRST_NUM

main :: proc() {

	the_number_pos := triangular(COL+ROW-2) + COL	// standard formula for ``anti-diagonal numbering`` mapping

	fmt.println(the_number_pos)		// the number of steps / position


	for _ in 1..<the_number_pos {
		final = next_number(final)
	}

	fmt.println(final)
}

triangular :: proc (val: u64) -> u64 {
	return (val * (val + 1)) / 2		// standard math formula for triangular numbers
}

next_number :: proc(number: u64) -> u64 {
	number := number
	return ((number * 252533) % 33554393)
}


// 20151125 is too high, 1726421 it too low, 4729349 is wrong, no hints, "guessed" wrong 4 times.
// 9177096 is wrong
// 18337615 steps, have to do next_number() on it, and I get 11436433. Wrong!! 
// I had the formula wrong, it's supposed to be ``triangular(COL+ROW-2) + COL``, it's a standard math formula I didn't know about. I tried to figure it out on my own and had arrived at this ``triangular(COL+ROW-1) + COL`` which is off by 1.
// With correct formula I now get this: 20087788. !! Wrong again, now I need to wait 10 minutes. I had a typo, it should have been: 9132360. 9132360 is correct, on the 8th attempt -_-'