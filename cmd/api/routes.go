package api

import (
	"net/http"

	"github.com/go-chi/chi/v5"
)

func (app *application) routes() http.Handler {
	mux := chi.NewRouter()

	mux.NotFound(app.notFound)
	mux.MethodNotAllowed(app.methodNotAllowed)

	mux.Use(app.recoverPanic)
	mux.Use(app.logRequestInfo)

	mux.Get("/status", app.status)

	mux.Route("/counter", func(r chi.Router) {
		r.Get("/", app.getCountValue)
		r.Put("/increment", app.incrementCount)
		r.Put("/decrement", app.decrementCount)
		r.Delete("/reset", app.resetCount)
	})

	return mux
}
