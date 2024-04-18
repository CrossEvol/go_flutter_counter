package main

import (
	"context"
	"database/sql"
	"errors"
	"flag"
	"fmt"
	"github.com/crossevol/go_flutter_counter/internal/database/dao"
	"log"
	"log/slog"
	"os"
	"runtime/debug"
	"sync"

	"github.com/crossevol/go_flutter_counter/internal/database"
	"github.com/crossevol/go_flutter_counter/internal/env"
	"github.com/crossevol/go_flutter_counter/internal/version"

	"github.com/lmittmann/tint"
)

func main() {
	logger := slog.New(tint.NewHandler(os.Stdout, &tint.Options{Level: slog.LevelDebug}))

	err := run(logger)
	if err != nil {
		trace := string(debug.Stack())
		logger.Error(err.Error(), "trace", trace)
		os.Exit(1)
	}
}

type config struct {
	baseURL  string
	httpPort int
	cookie   struct {
		secretKey string
	}
	db struct {
		dsn         string
		automigrate bool
	}
}

type application struct {
	config  config
	db      *database.DB
	queries *dao.Queries
	logger  *slog.Logger
	wg      sync.WaitGroup
	ctx     *context.Context
}

func run(logger *slog.Logger) error {
	var cfg config

	cfg.baseURL = env.GetString("BASE_URL", "http://localhost:4444")
	cfg.httpPort = env.GetInt("HTTP_PORT", 4444)
	cfg.cookie.secretKey = env.GetString("COOKIE_SECRET_KEY", "dtpbuthu2n774ayzvnotzhakebjn2hpw")
	cfg.db.dsn = env.GetString("DB_DSN", "db.sqlite")
	cfg.db.automigrate = env.GetBool("DB_AUTOMIGRATE", true)

	showVersion := flag.Bool("version", false, "display version and exit")

	flag.Parse()

	if *showVersion {
		fmt.Printf("version: %s\n", version.Get())
		return nil
	}

	ctx := context.Background()
	db, err := database.New(cfg.db.dsn, cfg.db.automigrate)
	if err != nil {
		return err
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

	app := &application{
		config:  cfg,
		db:      db,
		queries: queries,
		logger:  logger,
		ctx:     &ctx,
	}

	return app.serveHTTP()
}
