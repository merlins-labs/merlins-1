package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/cosmos/cosmos-sdk/server"
	genutiltypes "github.com/cosmos/cosmos-sdk/x/genutil/types"

	codectypes "github.com/cosmos/cosmos-sdk/codec/types"

	tmjson "github.com/tendermint/tendermint/libs/json"

	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"

	merlinApp "github.com/merlins-labs/merlin/app"
	"github.com/merlins-labs/merlin/x/concentrated-liquidity/model"

	cltypes "github.com/merlins-labs/merlin/x/concentrated-liquidity/types"
	clgenesis "github.com/merlins-labs/merlin/x/concentrated-liquidity/types/genesis"
	poolmanagertypes "github.com/merlins-labs/merlin/x/poolmanager/types"
)

func EditLocalMerlinGenesis(updatedCLGenesis *clgenesis.GenesisState, updatedBankGenesis *banktypes.GenesisState) {
	serverCtx := server.NewDefaultContext()
	config := serverCtx.Config

	config.SetRoot(localMerlinHomePath)
	config.Moniker = "localmerlin"

	genFile := config.GenesisFile()
	appState, genDoc, err := genutiltypes.GenesisStateFromGenFile(genFile)
	if err != nil {
		panic(err)
	}

	encodingConfig := merlinApp.MakeEncodingConfig()
	cdc := encodingConfig.Marshaler

	// Concentrated liquidity genesis.
	var localMerlinCLGenesis clgenesis.GenesisState
	cdc.MustUnmarshalJSON(appState[cltypes.ModuleName], &localMerlinCLGenesis)

	// Pool manager genesis.
	var localMerlinPoolManagerGenesis poolmanagertypes.GenesisState
	cdc.MustUnmarshalJSON(appState[poolmanagertypes.ModuleName], &localMerlinPoolManagerGenesis)

	var localMerlinBankGenesis banktypes.GenesisState
	cdc.MustUnmarshalJSON(appState[banktypes.ModuleName], &localMerlinBankGenesis)

	nextPoolId := localMerlinPoolManagerGenesis.NextPoolId
	localMerlinPoolManagerGenesis.NextPoolId = nextPoolId + 1
	localMerlinPoolManagerGenesis.PoolRoutes = append(localMerlinPoolManagerGenesis.PoolRoutes, poolmanagertypes.ModuleRoute{
		PoolType: poolmanagertypes.Concentrated,
		PoolId:   nextPoolId,
	})
	appState[poolmanagertypes.ModuleName] = cdc.MustMarshalJSON(&localMerlinPoolManagerGenesis)

	// Copy positions
	largestPositionId := uint64(0)
	for _, positionData := range updatedCLGenesis.PositionData {
		positionData.Position.PoolId = nextPoolId
		localMerlinCLGenesis.PositionData = append(localMerlinCLGenesis.PositionData, positionData)
		if positionData.Position.PositionId > largestPositionId {
			largestPositionId = positionData.Position.PositionId
		}
	}

	// Create map of pool balances
	balancesMap := map[string][]banktypes.Balance{}
	for _, balance := range updatedBankGenesis.Balances {
		if _, ok := balancesMap[balance.Address]; !ok {
			balancesMap[balance.Address] = []banktypes.Balance{}
		}
		balancesMap[balance.Address] = append(balancesMap[balance.Address], balance)
	}

	// Copy pool state, including ticks, incentive accums, records, and spread reward accumulators
	for _, pool := range updatedCLGenesis.PoolData {
		poolAny := pool.Pool

		var clPoolExt cltypes.ConcentratedPoolExtension
		err := cdc.UnpackAny(poolAny, &clPoolExt)
		if err != nil {
			panic(err)
		}

		clPool, error := clPoolExt.(*model.Pool)
		if !error {
			panic("Error converting pool")
		}
		clPool.Id = nextPoolId

		any, err := codectypes.NewAnyWithValue(clPool)
		if err != nil {
			panic(err)
		}
		anyCopy := *any

		for i := range pool.Ticks {
			pool.Ticks[i].PoolId = nextPoolId
		}

		for i := range pool.IncentiveRecords {
			pool.IncentiveRecords[i].PoolId = nextPoolId
		}

		for i := range pool.IncentivesAccumulators {
			pool.IncentivesAccumulators[i].Name = cltypes.KeyUptimeAccumulator(nextPoolId, uint64(i))
		}

		updatedPoolData := clgenesis.PoolData{
			Pool:                   &anyCopy,
			Ticks:                  pool.Ticks,
			IncentivesAccumulators: pool.IncentivesAccumulators,
			IncentiveRecords:       pool.IncentiveRecords,
			SpreadRewardAccumulator: clgenesis.AccumObject{
				Name:         cltypes.KeySpreadRewardPoolAccumulator(nextPoolId),
				AccumContent: pool.SpreadRewardAccumulator.AccumContent,
			},
		}

		// Update bank genesis with balances
		poolBalances := balancesMap[clPool.GetAddress().String()]
		localMerlinBankGenesis.Balances = append(localMerlinBankGenesis.Balances, poolBalances...)

		localMerlinCLGenesis.PoolData = append(localMerlinCLGenesis.PoolData, updatedPoolData)
	}

	localMerlinCLGenesis.NextPositionId = largestPositionId + 1

	appState[cltypes.ModuleName] = cdc.MustMarshalJSON(&localMerlinCLGenesis)

	// Persist updated bank genesis
	appState[banktypes.ModuleName] = cdc.MustMarshalJSON(&localMerlinBankGenesis)

	appStateJSON, err := json.Marshal(appState)
	if err != nil {
		panic(err)
	}

	genDoc.AppState = appStateJSON

	genesisJson, err := tmjson.MarshalIndent(genDoc, "", "  ")
	if err != nil {
		panic(err)
	}

	fmt.Printf("Writing genesis file to %s", localMerlinHomePath)
	start := time.Now()
	for time.Since(start) < 30*time.Second {
		if err := WriteFile(filepath.Join(localMerlinHomePath, "config", "genesis.json"), genesisJson); err == nil {
			fmt.Println("Genesis file written successfully")
			return
		} else {
			fmt.Printf("Error writing genesis file: %s\n", err.Error())
			time.Sleep(1 * time.Second)
		}
	}
	fmt.Println("Timed out after 30 seconds")
}

func WriteFile(path string, body []byte) error {
	_, err := os.Create(path)
	if err != nil {
		return err
	}

	return os.WriteFile(path, body, 0o600)
}
