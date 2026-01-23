# Map

Understanding `map` will allow you to make efficient use of them. Here are a few pointers.
Also see https://go.dev/blog/maps.

1. In general, they offer fast lookups, adds, and deletes.
2. `map[KeyType]ValueType` where KeyType may be any type that is comparable and ValueType may be any type, including another map!
3. Comparable types are boolean, numeric, string, pointer, channel, and interface types, and structs or arrays. Slices, maps, and functions cannot be compared.
4. `var m map[string]int` Map types are reference types, 
5. A nil map behaves like an empty map when reading, but attempts to write to a nil map will cause a runtime panic.
6. `m = make(map[string]int)` use the builtin `make` function to initialize a map.
7. `commits := map[string]int{ "rsc": 3711}` use a map literal to initialize a map with some data.
8. `j := m["root"] // j == 0` If the requested key doesn’t exist, we get the value type’s zero value.
9. `n := len(m)` The builtin len function returns on the number of items in a map.
10. `delete(m, "route")` The builtin delete function removes an entry from the map.
11. `i, ok := m["route"]` A two-value assignment tests for the existence of a key.
12. To iterate over the contents of a map, use the range keyword.
13. A map of boolean values can be used as a set-like data structure (recall that the zero value for the boolean type is false).
14. Appending to a nil slice just allocates a new slice, so it’s a one-liner to append a value to a map of slices; there’s no need to check if the key exists.
15. Maps are not safe for concurrent use as it’s not defined what happens when you read and write to them simultaneously.
16. When iterating over a map with a range loop, the iteration order is not specified and is not guaranteed to be the same from one iteration to the next. If you require a stable iteration order you must maintain a separate data structure that specifies that order.
