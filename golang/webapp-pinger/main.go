package main

import (
	"fmt"
	"github.com/kohirens/stdlib/logger"
	"net/http"
	"os"
	"path/filepath"
)

var (
	log = logger.Standard{}
)

func main() {
	var mainErr error

	defer func() {
		if mainErr != nil {
			log.Errf("mainErr: %v", mainErr)
		}
	}()

	logger.VerbosityLevel = 6

	args := os.Args
	log.Dbugf("args: %v", args)
	if len(args) < 2 {
		panic("the first argument must be a directory of the static HTML files")
	}

	wd, e1 := filepath.Abs(args[1])
	if e1 != nil {
		panic(fmt.Errorf("problem with the static files directory: %v", e1.Error()))
	}

	handy := &handler{
		staticDir:   wd + "/public",
		templateDir: wd + "/templates",
	}

	log.Infof("static files are expected to be in the directory: %v", handy.staticDir)

	// home-page
	http.HandleFunc("GET /{$}", handy.home)

	// ping-page
	http.HandleFunc("GET /ping", handy.ping)

	// pong-page
	http.HandleFunc("GET /pong", handy.pong)

	//mainErr = http.ListenAndServe(":8080", nil)
	mainErr = http.ListenAndServeTLS(
		":443",
		"/root/pki/certs/server.crt",
		"/root/pki/private/server.key",
		nil,
	)
}
