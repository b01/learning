package main

import "testing"

func Test_fmtIPv6(t *testing.T) {
	tests := []struct {
		name    string
		address string
		want    string
	}{
		// do not format if not a segements are greater than 4 chars long.
		{"not6", "adfasfd:sdafdas", "adfasfd:sdafdas"},
		// add square brackets if seems like a valid IPv6
		{"6", "fdee:b59c:c154::2", "[fdee:b59c:c154::2]"},
		// do not add square brackets if there are already brackets at the beginning and end.
		{"hasSquare", "[fdee:::2]", "[fdee:::2]"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := fmtIPv6(tt.address); got != tt.want {
				t.Errorf("fmtIPv6() = %v, want %v", got, tt.want)
			}
		})
	}
}
