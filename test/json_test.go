package main

import (
	"encoding/json"
	"fmt"
	"log"
	"testing"
)

// Only the CapitalCase Field can be public for serialization in Golang
func TestName(t *testing.T) {
	type config struct {
		url string
	}

	bytes, err := json.Marshal(config{url: "dev.db"})
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(string(bytes))
}
