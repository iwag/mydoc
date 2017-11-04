package hello

import (
	"net/http"
)

func init() {
	http.HandleFunc("/", redirect)
}

func redirect(w http.ResponseWriter, r *http.Request) {

	http.Redirect(w, r, "/portfolio/index.html", 301)
}

