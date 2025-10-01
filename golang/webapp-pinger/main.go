package main

import (
	"encoding/json"
	"fmt"
	"github.com/kohirens/stdlib/logger"
	"io"
	"net"
	"net/http"
	"os"
	"path/filepath"
	"time"
)

var log = logger.Standard{}

func main() {
	var mainErr error

	defer func() {
		if mainErr != nil {
			log.Errf("mainErr: %v", mainErr)
		}
	}()

	logger.VerbosityLevel = 6

	wd, e1 := os.Getwd()
	if e1 != nil {
		mainErr = fmt.Errorf("os.Getwd: %v", e1)
		return
	}

	args := os.Args
	fmt.Printf("args: %v", args)
	if len(args) < 2 {
		panic("the first argument must to a directory of the static HTML files")
	}

	staticDir := args[1]
	staticDir, e6 := filepath.Abs(staticDir)
	if e6 != nil {
		panic(fmt.Errorf("problem with the static files directory: %v", e6.Error()))
	}

	log.Infof("working directory: %v", wd)
	log.Infof("static files are expected to be in the directory: %v", staticDir)

	// home-page
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/html")

		bytes, e2 := os.ReadFile(wd + "/golang/webapp-pinger/public/index.html")
		if e2 != nil {
			w.WriteHeader(http.StatusInternalServerError)
			log.Errf("failed to read file: %v", e2.Error())
			return
		}
		_, err := w.Write(bytes)
		if err != nil {
			log.Errf("could not write response: %v", err)
		}
	})

	// ping-page
	http.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		if e := r.ParseForm(); e != nil {
			w.WriteHeader(http.StatusBadRequest)
			_, err := w.Write([]byte(e.Error()))
			if err != nil {
				log.Errf("Error writing response: %v", err)
			}
		}

		ping := r.Form.Get("ping")
		hc := &http.Client{}
		pingD := pingApp(ping, hc)
		_, err := w.Write(pingD)
		if err != nil {
			log.Errf("Error writing response: %v", err)
		}
	})

	// pong-page
	http.HandleFunc("/pong", func(w http.ResponseWriter, r *http.Request) {
		// IP address, hostname, server time
		w.Header().Set("Content-Type", "application/json")
		nfo, e3 := serverInfo()
		if e3 != nil {
			w.WriteHeader(http.StatusInternalServerError)
			log.Errf("serverInfo: %v", e3)
			return
		}
		encJson, e4 := json.Marshal(nfo)
		if e4 != nil {
			w.WriteHeader(http.StatusInternalServerError)
			log.Errf("json.Marshal: %v", e4.Error())
			return
		}
		_, e5 := w.Write(encJson)
		if e5 != nil {
			w.WriteHeader(http.StatusInternalServerError)
			log.Errf("w.Write: %v", e5.Error())
			return
		}
	})

	mainErr = http.ListenAndServe(":8080", nil)
}

func pingApp(ping string, hc *http.Client) []byte {
	res, e1 := hc.Get(ping)
	if e1 != nil {
		log.Errf("ping to %v failed: %v", ping, e1.Error())
		return nil
	}

	defer res.Body.Close()
	bodyD, e2 := io.ReadAll(res.Body)
	if e2 != nil {
		log.Errf("ping failed: %v", e2.Error())
		return nil
	}

	return bodyD
}

type server struct {
	Hostname string
	Adapters []*networkAdapter
	Time     time.Time
}
type networkAdapter struct {
	name string
	ips  []string
}

func serverInfo() (*server, error) {
	hostname, e1 := os.Hostname()
	if e1 != nil {
		return nil, fmt.Errorf("cannot get hostname: %v", e1.Error())
	}

	nfo := &server{
		Hostname: hostname,
		Adapters: make([]*networkAdapter, 10),
		Time:     time.Now(),
	}

	interfaces, e2 := net.Interfaces()
	if e2 != nil {
		return nil, fmt.Errorf("cannot get interfaces: %v", e2.Error())
	}

	var loopErr error
	for _, face := range interfaces {
		addrs, e3 := face.Addrs()
		if e3 != nil {
			loopErr = fmt.Errorf("cannot get addresses: %v", e3.Error())
			break
		}
		adapter := &networkAdapter{
			name: face.Name,
			ips:  make([]string, len(addrs)),
		}
		for _, addr := range addrs {
			adapter.ips = append(adapter.ips, addr.String())
		}
		nfo.Adapters = append(nfo.Adapters, adapter)
	}

	if loopErr != nil {
		return nil, loopErr
	}

	return nfo, nil
}
