package main

import (
	"crypto/tls"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"text/template"
)

const (
	fieldAddress = "address"
)

type handler struct {
	staticDir   string
	templateDir string
}

func (h *handler) home(w http.ResponseWriter, r *http.Request) {
	bytes, e2 := os.ReadFile(h.staticDir + "/index.html")
	if e2 != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Errf("failed to read file: %v", e2.Error())
		return
	}

	w.Header().Set("Content-Type", "text/html")
	_, err := w.Write(bytes)
	if err != nil {
		log.Errf("could not write response: %v", err)
	}
}

// loadTemplate Load and serve it as a response using text/template package.
func (h *handler) loadTemplate(name string, w http.ResponseWriter, data interface{}) error {
	// Use a template to inject the server info and dump out an HTML page.
	tmpl, e9 := template.ParseFiles(h.templateDir + name)
	if e9 != nil {
		return fmt.Errorf("cannot parse template: %v", e9.Error())
	}

	return tmpl.Execute(w, data)
}

// ping
//
//	Response codes:
//	  400 bad request.
//	  424 dependency failed. The requested action depended on another action, and that action failed.
//	  500 Internal error.
func (h *handler) ping(w http.ResponseWriter, r *http.Request) {
	// grab the IP/Domain to ping.
	if e := r.ParseForm(); e != nil {
		w.WriteHeader(http.StatusBadRequest)
		_, err := w.Write([]byte(e.Error()))
		if err != nil {
			log.Errf("could not parse the address to ping: %v", err)
		}
	}

	address := r.Form.Get(fieldAddress)
	// Form validation on "ping" otherwise return
	// code 422: the server understood the content type of the request
	// content, and the syntax of the request content was correct, but it
	// was unable to process the contained instructions.
	if e := validAddress(address); e != nil {
		w.WriteHeader(http.StatusUnprocessableEntity)
		_, _ = w.Write([]byte(fmt.Sprintf("<!DOCTYPE html><html><head><title>Unprocessable Entity(422)</title></head><body>%v</body></html>", e.Error())))
		w.Header().Set("Content-Type", "text/html")
		return
	}

	// Create a custom HTTP transport to disable TLS for the self-signed certs.
	hc := &http.Client{Transport: &http.Transport{
		TLSClientConfig: &tls.Config{
			InsecureSkipVerify: true, // This is the crucial line.
			VerifyConnection: func(cs tls.ConnectionState) error {
				return nil
			},
		},
	}}

	templateName := "/ping.html.tmpl"

	address = fmtIPv6(address)

	// Grab the info for the server to ping
	pongD := pingApp(address, hc)
	if pongD.Error != "" {
		w.WriteHeader(http.StatusFailedDependency)

		// Use a template to inject the server info and dump out an HTML page.
		templateName = "/failed-dependency.html.tmpl"
	}

	// Grab the info for this server.
	pingD := serverInfo()
	if pingD.Error != "" {
		w.WriteHeader(http.StatusFailedDependency)
	}

	// Use a template to inject the server info and dump out an HTML page.
	e10 := h.loadTemplate(templateName, w, map[string]*server{
		"Ping": pingD,
		"Pong": pongD,
	})
	if e10 != nil {
		w.WriteHeader(http.StatusInternalServerError)
		log.Errf("failed to load template: %v", e10.Error())
	}
}

// pong
func (h *handler) pong(w http.ResponseWriter, r *http.Request) {
	nfo := serverInfo()
	if nfo.Error != "" {
		w.WriteHeader(http.StatusFailedDependency)
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

	w.Header().Set("Content-Type", "application/json")
}
