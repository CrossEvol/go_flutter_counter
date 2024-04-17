package database

import (
	"context"
	"fmt"
	"github.com/crossevol/go_flutter_counter/internal/database/dao"
	_ "github.com/mattn/go-sqlite3" // Import the Sqlite driver
	"github.com/stretchr/testify/require"
	"github.com/stretchr/testify/suite"
	"os"
	"testing"
)

var queries *dao.Queries
var ctx = context.Background()
var db *DB

type DatabaseTestSuite struct {
	suite.Suite
	VariableThatShouldStartAtFive int
}

func (suite *DatabaseTestSuite) SetupSuite() {
	err := os.Remove("test.db")
	require.Nil(suite.T(), err)
	db, err = New("test.db", true)
	if err != nil {
		fmt.Println(err)
	}
	require.NotNil(suite.T(), db)
	queries = dao.New(db)
}

func (suite *DatabaseTestSuite) TearDownSuite() {
	db.Close()
}

func (suite *DatabaseTestSuite) SetupTest() {
	suite.VariableThatShouldStartAtFive = 5
}

func (suite *DatabaseTestSuite) TearDownTest() {
}

func (suite *DatabaseTestSuite) TestDatabase() {
	_, err := queries.InitCountValue(ctx)
	require.Nil(suite.T(), err)
	countValue, err := queries.GetCountValue(ctx)
	require.Nil(suite.T(), err)
	require.Zero(suite.T(), countValue)
	err = queries.IncrementCountValue(ctx)
	require.Nil(suite.T(), err)
	countValue, err = queries.GetCountValue(ctx)
	require.Nil(suite.T(), err)
	require.Equal(suite.T(), 1, int(countValue))
	err = queries.DecrementCountValue(ctx)
	require.Nil(suite.T(), err)
	countValue, err = queries.GetCountValue(ctx)
	require.Nil(suite.T(), err)
	require.Zero(suite.T(), countValue)
}

func TestDatabaseTestSuite(t *testing.T) {
	suite.Run(t, new(DatabaseTestSuite))
}
