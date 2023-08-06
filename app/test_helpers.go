package app

import (
	"encoding/json"
	"os"

	abci "github.com/tendermint/tendermint/abci/types"
	"github.com/tendermint/tendermint/libs/log"
	dbm "github.com/tendermint/tm-db"

	"github.com/cosmos/cosmos-sdk/simapp"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

var defaultGenesisBz []byte

func getDefaultGenesisStateBytes() []byte {
	if len(defaultGenesisBz) == 0 {
		genesisState := NewDefaultGenesisState()
		stateBytes, err := json.MarshalIndent(genesisState, "", " ")
		if err != nil {
			panic(err)
		}
		defaultGenesisBz = stateBytes
	}
	return defaultGenesisBz
}

// SetupWithCustomHome initializes a new MerlinApp with a custom home directory
func SetupWithCustomHome(isCheckTx bool, dir string) *MerlinApp {
	db := dbm.NewMemDB()
	app := NewMerlinApp(log.NewNopLogger(), db, nil, true, map[int64]bool{}, dir, 0, simapp.EmptyAppOptions{}, EmptyWasmOpts)
	if !isCheckTx {
		stateBytes := getDefaultGenesisStateBytes()

		app.InitChain(
			abci.RequestInitChain{
				Validators:      []abci.ValidatorUpdate{},
				ConsensusParams: simapp.DefaultConsensusParams,
				AppStateBytes:   stateBytes,
			},
		)
	}

	return app
}

// Setup initializes a new MerlinApp.
func Setup(isCheckTx bool) *MerlinApp {
	return SetupWithCustomHome(isCheckTx, DefaultNodeHome)
}

// SetupTestingAppWithLevelDb initializes a new MerlinApp intended for testing,
// with LevelDB as a db.
func SetupTestingAppWithLevelDb(isCheckTx bool) (app *MerlinApp, cleanupFn func()) {
	dir, err := os.MkdirTemp(os.TempDir(), "merlin_leveldb_testing")
	if err != nil {
		panic(err)
	}
	db, err := sdk.NewLevelDB("merlin_leveldb_testing", dir)
	if err != nil {
		panic(err)
	}
	app = NewMerlinApp(log.NewNopLogger(), db, nil, true, map[int64]bool{}, DefaultNodeHome, 5, simapp.EmptyAppOptions{}, EmptyWasmOpts)
	if !isCheckTx {
		genesisState := NewDefaultGenesisState()
		stateBytes, err := json.MarshalIndent(genesisState, "", " ")
		if err != nil {
			panic(err)
		}

		app.InitChain(
			abci.RequestInitChain{
				Validators:      []abci.ValidatorUpdate{},
				ConsensusParams: simapp.DefaultConsensusParams,
				AppStateBytes:   stateBytes,
			},
		)
	}

	cleanupFn = func() {
		db.Close()
		err = os.RemoveAll(dir)
		if err != nil {
			panic(err)
		}
	}

	return app, cleanupFn
}
