package main

import "C"
import (
	"context"
	"database/sql"
	"errors"
	"flag"
	"fmt"
	"github.com/crossevol/go_flutter_counter/internal/database"
	"github.com/crossevol/go_flutter_counter/internal/database/dao"
	"github.com/crossevol/go_flutter_counter/internal/env"
	"github.com/crossevol/go_flutter_counter/internal/version"
	"github.com/lmittmann/tint"
	"log"
	"log/slog"
	"net"
	"net/http"
	"os"
)

var srv *http.Server

//export StartDesktopServer
func StartDesktopServer() (int, *C.char) {
	var cfg config

	cfg.cookie.secretKey = env.GetString("COOKIE_SECRET_KEY", "dtpbuthu2n774ayzvnotzhakebjn2hpw")
	cfg.db.dsn = env.GetString("DB_DSN", "db.sqlite")
	cfg.db.automigrate = env.GetBool("DB_AUTOMIGRATE", true)

	showVersion := flag.Bool("version", false, "display version and exit")

	flag.Parse()

	if *showVersion {
		fmt.Printf("version: %s\n", version.Get())
	}

	ctx := context.Background()
	db, err := database.New(cfg.db.dsn, cfg.db.automigrate)
	if err != nil {
		return 0, C.CString(err.Error())
	}
	defer db.Close()
	queries := dao.New(db)
	if _, err := queries.GetCountValue(ctx); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			if _, err := queries.InitCountValue(ctx); err != nil {
				log.Fatal("Failed to init the counter value...")
			}
		}
	}
	defer queries.Close()

	logger := slog.New(tint.NewHandler(os.Stdout, &tint.Options{Level: slog.LevelDebug}))

	app := &application{
		config:  cfg,
		db:      db,
		queries: queries,
		logger:  logger,
		ctx:     &ctx,
	}
	srv = &http.Server{
		Handler:      app.routes(),
		ErrorLog:     slog.NewLogLogger(app.logger.Handler(), slog.LevelWarn),
		IdleTimeout:  defaultIdleTimeout,
		ReadTimeout:  defaultReadTimeout,
		WriteTimeout: defaultWriteTimeout,
	}

	listener, err := net.Listen("tcp", "127.0.0.1:0")
	if err != nil {
		return 0, C.CString(err.Error())
	}

	go func() {
		err = srv.Serve(listener)
		if err != nil {
			log.Fatal(err)
		}
	}()

	port := 0
	if addr, ok := listener.Addr().(*net.TCPAddr); ok {
		port = addr.Port
	}

	return port, nil
}

//export StopDesktopServer
func StopDesktopServer() {
	if srv != nil {
		if err := srv.Shutdown(context.TODO()); err != nil {
			log.Fatal("shutdown server failed")
		}
	}
}
