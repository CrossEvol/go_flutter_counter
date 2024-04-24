package main

import "C"
import (
	"github.com/crossevol/go_flutter_counter/cmd/api"
	"log"
)

func main() {
}

//export Start
func Start(config *C.char) (int, *C.char) {
	port, err := api.StartServer(C.GoString(config))
	if err != nil {
		log.Fatal(err)
		return 0, C.CString(err.Error())
	}
	return port, nil
}

//export Stop
func Stop() {
	api.StopServer()
}
