// Hacky but did the job

package aoc

import "core:fmt"
import "core:slice"

current_time := 0
TIME_LIMIT :: 2503

cycles_count: [Raindeer]int
time_per_cycle: [Raindeer]int
remainder_time: [Raindeer]int
partial_distance: [Raindeer]int
final_distance: [Raindeer]int
current_max_array: [Raindeer]int
current_max: int
total_points: int

Raindeer :: enum {
	Rudolph,
	Cupid,
	Prancer,
	Donner,
	Dasher,
	Comet,
	Blitzen,
	Vixen,
	Dancer,
}

Stats :: struct {
	speed: int,
	flight_time: int,
	rest_time: int,
}

stats := [Raindeer]Stats {
	.Rudolph = {22, 8, 165},
	.Cupid = {8, 17, 114},
	.Prancer = {18, 6, 103},
	.Donner = {25, 6, 145},
	.Dasher = {11, 12, 125},
	.Comet = {21, 6, 121},
	.Blitzen = {18, 3, 50},
	.Vixen = {20, 4, 75},
	.Dancer = {7, 20, 119},
}

get_cycles :: proc (stat: Stats) -> (counter, one_cycle_time, remainder_time: int) {
	one_cycle_time = stat.flight_time + stat.rest_time
	counter = current_time / one_cycle_time
	remainder_time = current_time - (counter * one_cycle_time)
	return counter, one_cycle_time, remainder_time
}

save_cycles :: proc () {
	for raindeer_stats, raindeer_key in stats {
		cycles_count[raindeer_key], time_per_cycle[raindeer_key], remainder_time[raindeer_key] = get_cycles(raindeer_stats)
		// fmt.println(cycles_count[raindeer_key])
	}
}

find_max :: proc (arr: [Raindeer]int) -> (int) {
	values := make([]int, len(Raindeer))
	i := 0
    for value, _ in arr {
        values[i] = value
        i += 1
    }
	slice.sort(values[:])
	max_val := values[len(values)-1]
	return max_val
}

main :: proc () {
	// fmt.println(stats)

	for _ in 0..<2503 {
		current_time += 1
		save_cycles()
		// remainder(stats)

		for raindeer_stats, raindeer_key in stats {
			partial_distance[raindeer_key] = cycles_count[raindeer_key] * raindeer_stats.speed * raindeer_stats.flight_time
		}

		for raindeer_stats, raindeer_key in stats {
			switch {
			case remainder_time[raindeer_key] >= raindeer_stats.flight_time:
				final_distance[raindeer_key] = partial_distance[raindeer_key] + raindeer_stats.flight_time * raindeer_stats.speed
			case:
				final_distance[raindeer_key] = partial_distance[raindeer_key] + (remainder_time[raindeer_key] * raindeer_stats.speed)
			}

		}
		
		for _, raindeer_key in stats {
			current_max_array[raindeer_key] = final_distance[raindeer_key]
		}
		current_max = find_max(current_max_array)
		if final_distance[.Dancer] == current_max { total_points += 1}
	}



	fmt.printfln("%v\n%v\n%v\n%v\n%v\n%v", cycles_count, time_per_cycle, remainder_time, partial_distance, final_distance, total_points)
}


/* stats[0] is the speed in km/s, stats[1] is the duration of the flight in seconds, stats[2] is the rest in between flights, in seconds. Thus, a single cycle lasts stats[1]+stats[2]. The total number of cycles is current_time / single cycle duration, plus some remainder.

 o  first answer 2468 is wrong, too high !!
 o  Oops winner was Cupid, not Donner!
 o  Damn, the math was wrong, I was adding the points 9 times per second. Fixed the loop.
 o  838 for Cupid is too low apparently. I assumed Cupid won the points too but maybe a different horse did. I will just check them manually and see the highest:

Rudolph = 1084 !! I guess we have a winner... on a technicality.
Cupid = 838
Prancer = 24
Donner = 277
Dasher = 0
Comet = 121
Blitzen = 0
Vixen = 13
Dancer = 199

*/