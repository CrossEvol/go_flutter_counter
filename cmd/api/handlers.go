package main

import (
	"database/sql"
	"net/http"

	"github.com/crossevol/go_flutter_counter/internal/response"
)

func (app *application) status(w http.ResponseWriter, r *http.Request) {
	data := map[string]string{
		"Status": "OK",
	}

	err := response.JSON(w, http.StatusOK, data)
	if err != nil {
		app.serverError(w, r, err)
	}
}

type GetCounterResult struct {
	Count int `json:"count"`
}

func (app *application) getCountValue(w http.ResponseWriter, r *http.Request) {
	countValue, err := app.queries.GetCountValue(*app.ctx)
	if err != nil {
		app.serverError(w, r, err)
	}
	response.JSON(w, http.StatusOK, GetCounterResult{Count: int(countValue)})
}

func (app *application) incrementCount(w http.ResponseWriter, r *http.Request) {
	tx, err := app.db.Begin()
	if err != nil {
		app.serverError(w, r, err)
	}
	defer tx.Rollback()
	qtx := app.queries.WithTx(tx)
	oldCountValue, err := qtx.GetCountValue(*app.ctx)
	if err != nil {
		app.serverError(w, r, err)
	}
	if _, err := qtx.CreateCounterRecord(*app.ctx, sql.NullInt64{Valid: true, Int64: oldCountValue + 1}); err != nil {
		app.serverError(w, r, err)
	}
	if err := qtx.IncrementCountValue(*app.ctx); err != nil {
		app.serverError(w, r, err)
	}
	if err := tx.Commit(); err != nil {
		app.serverError(w, r, err)
	}
	response.JSON(w, http.StatusOK, nil)
}

func (app *application) decrementCount(w http.ResponseWriter, r *http.Request) {
	tx, err := app.db.Begin()
	if err != nil {
		app.serverError(w, r, err)
	}
	defer tx.Rollback()
	qtx := app.queries.WithTx(tx)
	oldCountValue, err := qtx.GetCountValue(*app.ctx)
	if err != nil {
		app.serverError(w, r, err)
	}
	if _, err := qtx.CreateCounterRecord(*app.ctx, sql.NullInt64{Valid: true, Int64: oldCountValue - 1}); err != nil {
		app.serverError(w, r, err)
	}
	if err := qtx.DecrementCountValue(*app.ctx); err != nil {
		app.serverError(w, r, err)
	}
	if err := tx.Commit(); err != nil {
		app.serverError(w, r, err)
	}
	response.JSON(w, http.StatusOK, nil)
}

func (app *application) resetCount(w http.ResponseWriter, r *http.Request) {
	tx, err := app.db.Begin()
	if err != nil {
		app.serverError(w, r, err)
	}
	defer tx.Rollback()
	qtx := app.queries.WithTx(tx)
	if _, err := qtx.CreateCounterRecord(*app.ctx, sql.NullInt64{Valid: true, Int64: 0}); err != nil {
		app.serverError(w, r, err)
	}
	if err := qtx.ResetCountValue(*app.ctx); err != nil {
		app.serverError(w, r, err)
	}
	if err := tx.Commit(); err != nil {
		app.serverError(w, r, err)
	}
	response.JSON(w, http.StatusOK, nil)
}
