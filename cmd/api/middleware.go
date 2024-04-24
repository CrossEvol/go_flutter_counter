package api

import (
	"fmt"
	"net/http"
)

func (app *application) recoverPanic(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		defer func() {
			err := recover()
			if err != nil {
				app.serverError(w, r, fmt.Errorf("%s", err))
			}
		}()

		next.ServeHTTP(w, r)
	})
}

func (app *application) logRequestInfo(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// Log request details
		app.logger.Info(fmt.Sprintf("%s %s %s", colorized(r.Method), r.URL.Path, r.RemoteAddr))

		// Call the next handler in the chain
		next.ServeHTTP(w, r)
	})
}

func colorized(method string) string {
	color := ""
	switch method {
	case http.MethodGet:
		color = "\033[34m%s\033[0m" // Blue
	case http.MethodPost:
		color = "\033[32m%s\033[0m" // Green
	case http.MethodPut, http.MethodPatch:
		color = "\033[33m%s\033[0m" // Yellow
	case http.MethodDelete:
		color = "\033[31m%s\033[0m" // Red
	default:
		color = "\033[35m%s\033[0m" // Magenta (for unknown methods)
	}
	return fmt.Sprintf(color, method)
}
