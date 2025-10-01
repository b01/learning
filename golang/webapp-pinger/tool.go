package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"regexp"
	"strings"
	"time"
)

// server Represents simple server information.
// Originally designed for UI consumption.
type server struct {
	Adapters []*networkAdapter
	Hostname string
	Error    string
	Time     time.Time
}

// networkAdapter Represents a network interface and its assigned IP addresses.
// Originally designed for UI consumption.
type networkAdapter struct {
	Name string
	Ips  []string
}

// fmtIPv6 detect IPv6 address and wrap in square brackets.
//
//	NOTES:
//	  Do not format if not a segments are greater than 4 chars long;
//	  Add square brackets if seems like a valid IPv6;
//	  Do not add square brackets if there are already brackets at the beginning
//	  and end.
func fmtIPv6(address string) string {
	l := len(address)
	if l > 0 && strings.Index(address, `:`) != -1 && (address[0] != '[' || address[l-1] != ']') {

		parts := strings.Split(address, ":")
		for _, p := range parts {
			if len(p) > 4 {
				return address
			}
		}

		return "[" + address + "]"
	}
	return address
}

// pingApp ping the `/pong` endpoint to a listening application at the address.
func pingApp(address string, hc *http.Client) *server {
	nfo := &server{}
	res, e1 := hc.Get("https://" + address + "/pong")
	if e1 != nil {
		nfo.Error = fmt.Sprintf("ping to %v failed: %v", address, e1.Error())
		return nfo
	}

	defer res.Body.Close()

	bodyD, e2 := io.ReadAll(res.Body)
	if e2 != nil {
		nfo.Error = fmt.Sprintf("unable to read the pong response: %v", e2.Error())
		return nfo
	}

	if e3 := json.Unmarshal(bodyD, nfo); e3 != nil {
		nfo.Error = fmt.Sprintf("unable to parse the pong response: %v", e3.Error())
	}

	return nfo
}

// serverInfo IP address, hostname, server time, etc.
func serverInfo() *server {
	nfo := &server{
		Time: time.Now(),
	}

	hostname, e1 := os.Hostname()
	if e1 != nil {
		nfo.Error = fmt.Sprintf("cannot get hostname: %v", e1.Error())
	}

	nfo.Hostname = hostname

	interfaces, e2 := net.Interfaces()
	if e2 != nil {
		nfo.Error = fmt.Sprintf("cannot get interfaces: %v", e2.Error())
	}

	nfo.Adapters = make([]*networkAdapter, len(interfaces))

	for i, face := range interfaces {
		addrs, e3 := face.Addrs()
		if e3 != nil {
			nfo.Error = fmt.Sprintf("cannot get addresses: %v", e3.Error())
			break
		}
		adapter := &networkAdapter{
			Name: face.Name,
			Ips:  make([]string, len(addrs)),
		}
		for j, addr := range addrs {
			adapter.Ips[j] = addr.String()
		}
		nfo.Adapters[i] = adapter
	}

	return nfo
}

// validAddress Simple field validate for an IP address, domain, or hostname.
func validAddress(address string) error {
	re := regexp.MustCompile(`[a-zA-Z0-9.\-_:]{1,253}`)
	if re.MatchString(address) {
		return nil
	}

	return fmt.Errorf("invalid address: %v", address)
}
