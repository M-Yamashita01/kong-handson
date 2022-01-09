package main

import (
	"encoding/json"
	"net/http"
)

type Client struct {
	CompanyName string `json:"companyName"`
	Email       string `json:"email"`
}

func clients(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	user := Client{
		CompanyName: "John Inc.",
		Email:       "john@example.com",
	}
	var clients []Client
	clients = append(clients, user)
	json.NewEncoder(w).Encode(clients)
}

func main() {
	http.HandleFunc("/clients", clients)
	http.ListenAndServe(":8003", nil)
}
