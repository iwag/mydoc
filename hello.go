package main

import (
	"html/template"
	"log"
	"net/http"
	"os"
	"path/filepath"
)

var (
	indexTmpl = template.Must(
		template.ParseFiles(filepath.Join("portfolio", "index.html")),
	)
)

func main() {
	http.HandleFunc("/", indexHandler)

	public := http.StripPrefix("/portfolio", http.FileServer(http.Dir("portfolio")))
	http.Handle("/portfolio/", public)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
		log.Printf("Defaulting to port %s", port)
	}

	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return
	}
	if err := indexTmpl.Execute(w, struct {}{}); err != nil {
		log.Printf("Error executing template: %v", err)
		http.Error(w, "Internal server error", http.StatusInternalServerError)
	}
}
