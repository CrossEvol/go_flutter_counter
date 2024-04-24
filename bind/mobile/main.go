package HttpServer

// #cgo LDFLAGS: -static-libstdc++
import "C"
import "github.com/crossevol/go_flutter_counter/cmd/api"

func Start(config string) (int, error) {
	port, err := api.StartServer(config)
	if err != nil {
		return 0, err
	}
	return port, nil
}

func Stop() {
	api.StopServer()
}
