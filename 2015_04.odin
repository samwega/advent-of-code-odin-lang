// 2.28 seconds for six 0s ( 14s for seven 0s, crashed laptop on eight 0s)
package aoc

import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:encoding/hex"
import "core:crypto/legacy/md5"
import "core:time"

input := "yzbqklnj"
decimal_suffix := 1
buf: [16]byte
my_context: md5.Context

main :: proc() {
	start_time := time.now()
	
	for {
		md5.init(&my_context)		// Initialize context
		string_suffix:= strconv.itoa(buf[:], decimal_suffix)

		crack := strings.concatenate({input, string_suffix})
		md5.update(&my_context, transmute([]u8)crack)
		// fmt.print(my_context)

		hash: [md5.DIGEST_SIZE]u8
		md5.final(&my_context, hash[:])
		// fmt.println(hash[:])					// not in hex format

		hex_string:= hex.encode(hash[:])		// now converted to hex format ??
		defer delete(hex_string)

		// fmt.println(i, string(hex_string))			// needs string() to actually come out as hex for some reason

		if !strings.has_prefix(string(hex_string), "000000") {	// works for arbitrary number of 0s, up to 7.
			decimal_suffix += 1
		} else {
			end_time := time.now()
			elapsed := time.diff(start_time, end_time)

			fmt.println("I got it: ", string_suffix)
			fmt.println("Time taken:", elapsed)
			fmt.println("Total iterations:", decimal_suffix)

			break
		}
	}
}
