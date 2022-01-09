package main

import (
	"encoding/json"
	"net/http"
)

type User struct {
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
}

func users(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	user := User{
		FirstName: "John",
		LastName:  "Doe",
	}
	var users []User
	users = append(users, user)
	json.NewEncoder(w).Encode(users)
}

func main() {
	http.HandleFunc("/users", users)
	http.ListenAndServe(":8002", nil)
}
