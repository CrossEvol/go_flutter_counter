package http_server

// #cgo LDFLAGS: -static-libstdc++
import "C"
import "github.com/crossevol/go_flutter_counter/cmd/api"

func Start(config string) (int, string) {
	port, err := api.StartServer(config)
	if err != nil {
		return 0, err.Error()
	}
	return port, ""
}

func Stop() {
	api.StopServer()
}
