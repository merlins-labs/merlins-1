package main

import (
	"encoding/json"
	"fmt"
	"math/rand"
	"os"

	"github.com/cosmos/cosmos-sdk/baseapp"
	"github.com/cosmos/cosmos-sdk/simapp"
	sdk "github.com/cosmos/cosmos-sdk/types"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"

	"github.com/osmosis-labs/osmosis/osmomath"
	"github.com/osmosis-labs/osmosis/osmoutils/accum"
	"github.com/merlinslair/merlin/v16/app"
	"github.com/merlinslair/merlin/v16/app/apptesting"
	cl "github.com/merlinslair/merlin/v16/x/concentrated-liquidity"
	"github.com/merlinslair/merlin/v16/x/concentrated-liquidity/math"
	"github.com/merlinslair/merlin/v16/x/concentrated-liquidity/model"
	cltypes "github.com/merlinslair/merlin/v16/x/concentrated-liquidity/types"
	clgenesis "github.com/merlinslair/merlin/v16/x/concentrated-liquidity/types/genesis"
)

type BigBangPositions struct {
	PositionsData []clgenesis.PositionData `json:"position_data"`
}

type MerlinApp struct {
	App         *app.MerlinApp
	Ctx         sdk.Context
	QueryHelper *baseapp.QueryServiceTestHelper
	TestAccs    []sdk.AccAddress
}

var merlinPrecision = 6

func ReadSubgraphDataFromDisk(subgraphFilePath string) []SubgraphPosition {
	// read in the data from file
	data, err := os.ReadFile(subgraphFilePath)
	if err != nil {
		fmt.Println("Error reading file:", err)
		os.Exit(1)
	}

	// unmarshal the data into a slice of Position structs
	var positions []SubgraphPosition
	err = json.Unmarshal(data, &positions)
	if err != nil {
		fmt.Println("Error unmarshalling data:", err)
		os.Exit(1)
	}

	return positions
}

func ConvertSubgraphToMerlinGenesis(positionCreatorAddresses []sdk.AccAddress, subgraphFilePath string) (*clgenesis.GenesisState, *banktypes.GenesisState) {
	positions := ReadSubgraphDataFromDisk(subgraphFilePath)

	merlin := apptesting.KeeperTestHelper{}
	merlin.Setup()

	if len(positionCreatorAddresses) == 0 {
		panic("no accounts found")
	}

	merlin.TestAccs = make([]sdk.AccAddress, len(positionCreatorAddresses))
	for i := 0; i < len(positionCreatorAddresses); i++ {
		merlin.TestAccs[i] = positionCreatorAddresses[i]
		fmt.Println(merlin.TestAccs[i].String())
	}

	initAmounts := sdk.NewCoins(
		sdk.NewCoin(denom0, sdk.NewInt(1000000000000000000)),
		sdk.NewCoin(denom1, sdk.NewInt(1000000000000000000)),
	)

	// fund all accounts
	for _, acc := range merlin.TestAccs {
		err := simapp.FundAccount(merlin.App.BankKeeper, merlin.Ctx, acc, initAmounts)
		if err != nil {
			panic(err)
		}
	}

	msgCreatePool := model.MsgCreateConcentratedPool{
		Sender:       merlin.TestAccs[0].String(),
		Denom0:       denom0,
		Denom1:       denom1,
		TickSpacing:  100,
		SpreadFactor: sdk.MustNewDecFromStr("0.0005"),
	}

	err := msgCreatePool.ValidateBasic()
	if err != nil {
		panic(err)
	}

	poolId, err := merlin.App.PoolManagerKeeper.CreatePool(merlin.Ctx, msgCreatePool)
	if err != nil {
		panic(err)
	}

	fmt.Println("Created pool id of: ", poolId)

	pool, err := merlin.App.ConcentratedLiquidityKeeper.GetConcentratedPoolById(merlin.Ctx, poolId)
	if err != nil {
		panic(err)
	}

	// Initialize first position to be 1:1 price
	// this is because the first position must have non-zero token0 and token1 to initialize the price
	// however, our data has first position with non-zero amount.
	_, _, _, _, err = merlin.App.ConcentratedLiquidityKeeper.CreateFullRangePosition(merlin.Ctx, pool.GetId(), merlin.TestAccs[0], sdk.NewCoins(sdk.NewCoin(msgCreatePool.Denom0, sdk.NewInt(100)), sdk.NewCoin(msgCreatePool.Denom1, sdk.NewInt(100))))
	if err != nil {
		panic(err)
	}

	clMsgServer := cl.NewMsgServerImpl(merlin.App.ConcentratedLiquidityKeeper)

	numberOfSuccesfulPositions := 0

	bigBangPositions := make([]clgenesis.PositionData, 0)

	for _, uniV3Position := range positions {
		lowerPrice := parsePrice(uniV3Position.TickLower.Price0)
		upperPrice := parsePrice(uniV3Position.TickUpper.Price0)
		if err != nil {
			panic(err)
		}

		if lowerPrice.GTE(upperPrice) {
			fmt.Printf("lowerPrice (%s) >= upperPrice (%s), skipping", lowerPrice, upperPrice)
			continue
		}

		sqrtPriceLower, err := lowerPrice.ApproxRoot(2)
		if err != nil {
			panic(err)
		}
		lowerTickMerlin, err := math.SqrtPriceToTickRoundDownSpacing(sqrtPriceLower, pool.GetTickSpacing())
		if err != nil {
			panic(err)
		}

		sqrtPriceUpper, err := upperPrice.ApproxRoot(2)
		if err != nil {
			panic(err)
		}
		upperTickMerlin, err := math.SqrtPriceToTickRoundDownSpacing(sqrtPriceUpper, pool.GetTickSpacing())
		if err != nil {
			panic(err)
		}

		if lowerTickMerlin > upperTickMerlin {
			fmt.Printf("lowerTickMerlin (%d) > upperTickMerlin (%d), skipping", lowerTickMerlin, upperTickMerlin)
			continue
		}

		if lowerTickMerlin == upperTickMerlin {
			// bump up the upper tick by one. We don't care about having exactly the same tick range
			// Just a roughly similar breakdown
			upperTickMerlin = upperTickMerlin + 1
		}

		depositedAmount0, failedParsing := parseStringToInt(uniV3Position.DepositedToken0)
		if failedParsing {
			fmt.Printf("Failed parsing %s, skipping", uniV3Position.DepositedToken0)
			continue
		}

		depositedAmount1, failedParsing := parseStringToInt(uniV3Position.DepositedToken1)
		if failedParsing {
			fmt.Printf("Failed parsing %s, skipping", uniV3Position.DepositedToken0)
			continue
		}

		tokensProvided := sdk.NewCoins(sdk.NewCoin(msgCreatePool.Denom0, depositedAmount0), sdk.NewCoin(msgCreatePool.Denom1, depositedAmount1))

		randomCreator := merlin.TestAccs[rand.Intn(len(merlin.TestAccs))]

		position, err := clMsgServer.CreatePosition(sdk.WrapSDKContext(merlin.Ctx), &cltypes.MsgCreatePosition{
			PoolId:          poolId,
			Sender:          randomCreator.String(),
			LowerTick:       lowerTickMerlin,
			UpperTick:       upperTickMerlin,
			TokensProvided:  tokensProvided,
			TokenMinAmount0: sdk.ZeroInt(),
			TokenMinAmount1: sdk.ZeroInt(),
		})
		if err != nil {
			fmt.Printf("\n\n\nWARNING: Failed to create position: %v\n\n\n", err)
			fmt.Printf("attempted creation between ticks (%d) and (%d), desired amount 0: (%s), desired amount 1 (%s)\n", lowerTickMerlin, upperTickMerlin, depositedAmount0, depositedAmount1)
			fmt.Println()
			continue
		}

		fmt.Printf("created position with liquidity (%s) between ticks (%d) and (%d)\n", position.LiquidityCreated, lowerTickMerlin, upperTickMerlin)
		numberOfSuccesfulPositions++

		bigBangPositions = append(bigBangPositions, clgenesis.PositionData{
			Position: &model.Position{
				Address:    randomCreator.String(),
				PoolId:     poolId,
				JoinTime:   merlin.Ctx.BlockTime(),
				Liquidity:  position.LiquidityCreated,
				PositionId: position.PositionId,
				LowerTick:  lowerTickMerlin,
				UpperTick:  upperTickMerlin,
			},
			SpreadRewardAccumRecord: accum.Record{
				NumShares: position.LiquidityCreated,
			},
		})
	}

	fmt.Printf("\nout of %d uniswap positions, %d were successfully created\n", len(positions), numberOfSuccesfulPositions)

	if writeBigBangConfigToDisk {
		writeBigBangPositionsToState(bigBangPositions)
	}

	if writeGenesisToDisk {
		state := merlin.App.ExportState(merlin.Ctx)
		writeStateToDisk(state)
	}

	clGenesis := merlin.App.ConcentratedLiquidityKeeper.ExportGenesis(merlin.Ctx)
	bankGenesis := merlin.App.BankKeeper.ExportGenesis(merlin.Ctx)
	return clGenesis, bankGenesis
}

func parsePrice(strPrice string) (result sdk.Dec) {
	defer func() {
		r := recover()
		if r != nil {
			fmt.Printf("Recovered in price parsing %s, %s\n", r, strPrice)
			if strPrice[0] == '0' {
				result = cltypes.MinSpotPrice
			} else {
				result = cltypes.MaxSpotPrice
			}
		}

		if result.GT(cltypes.MaxSpotPrice) {
			result = cltypes.MaxSpotPrice
		}

		if result.LT(cltypes.MinSpotPrice) {
			result = cltypes.MinSpotPrice
		}
	}()
	result = furymath.MustNewDecFromStr(strPrice).SDKDec()
	return result
}

func parseStringToInt(strInt string) (result sdk.Int, failedParsing bool) {
	defer func() {
		r := recover()
		if r != nil {
			fmt.Printf("Recovered in int parsing %s, %s\n", r, strInt)
			failedParsing = true
		}
	}()
	result = furymath.MustNewDecFromStr(strInt).SDKDec().MulInt64(int64(merlinPrecision)).TruncateInt()
	return result, failedParsing
}

func writeStateToDisk(state map[string]json.RawMessage) {
	stateBz, err := json.MarshalIndent(state, "", "    ")
	if err != nil {
		panic(err)
	}

	err = os.WriteFile(pathToFilesFromRoot+merlinGenesisFileName, stateBz, 0o644)
	if err != nil {
		panic(err)
	}
}

func writeBigBangPositionsToState(positions []clgenesis.PositionData) {
	fmt.Println("writing big bang positions to disk")
	positionsBytes, err := json.MarshalIndent(BigBangPositions{
		PositionsData: positions,
	}, "", "    ")
	if err != nil {
		panic(err)
	}
	err = os.WriteFile(pathToFilesFromRoot+bigbangPosiionsFileName, positionsBytes, 0o644)
	if err != nil {
		panic(err)
	}
}
