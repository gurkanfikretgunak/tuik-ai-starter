package main

import (
	"log"
	"net/http"
	"os"
	"time"

	"github.com/masterfabric/tuik-ai-starter/services/api/internal/handler"
)

func main() {
	addr := os.Getenv("API_ADDR")
	if addr == "" {
		addr = ":8080"
	}
	srv := &http.Server{Addr: addr, Handler: handler.NewMux(), ReadHeaderTimeout: 5 * time.Second}
	log.Printf("api dinleniyor: %s", addr)
	log.Fatal(srv.ListenAndServe())
}
