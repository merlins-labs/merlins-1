package v14_test

import (
	"reflect"
	"testing"

	gamm "github.com/osmosis-labs/osmosis/v14/x/gamm/keeper"

	"github.com/stretchr/testify/suite"

	"github.com/osmosis-labs/osmosis/v14/app/apptesting"
	v14 "github.com/osmosis-labs/osmosis/v14/app/upgrades/v14"
)

type UpgradeTestSuite struct {
	apptesting.KeeperTestHelper
}

func (suite *UpgradeTestSuite) SetupTest() {
	suite.Setup()
}

func TestUpgradeTestSuite(t *testing.T) {
	suite.Run(t, new(UpgradeTestSuite))
}

func (suite *UpgradeTestSuite) TestMigrateNextPoolIdAndCreatePool() {
	suite.SetupTest() // reset

	const (
		expectedNextPoolId uint64 = 1
	)

	var (
		gammKeeperType = reflect.TypeOf(&gamm.Keeper{})
	)

	ctx := suite.Ctx
	gammKeeper := suite.App.GAMMKeeper
	poolmanagerKeeper := suite.App.PoolManagerKeeper

	nextPoolId := gammKeeper.GetNextPoolId(ctx)
	suite.Require().Equal(expectedNextPoolId, nextPoolId)

	// system under test.
	v14.MigrateNextPoolId(ctx, gammKeeper, poolmanagerKeeper)

	// validate poolmanager's next pool id.
	actualNextPoolId := poolmanagerKeeper.GetNextPoolId(ctx)
	suite.Require().Equal(expectedNextPoolId, actualNextPoolId)

	// create a pool after migration.
	actualCreatedPoolId := suite.PrepareBalancerPool()
	suite.Require().Equal(expectedNextPoolId, actualCreatedPoolId)

	// validate that module route mapping has been created for each pool id.
	for poolId := uint64(1); poolId < expectedNextPoolId; poolId++ {
		swapModule, err := poolmanagerKeeper.GetPoolModule(ctx, poolId)
		suite.Require().NoError(err)

		suite.Require().Equal(gammKeeperType, reflect.TypeOf(swapModule))
	}

	// validate params
	gammPoolCreationFee := gammKeeper.GetParams(ctx).PoolCreationFee
	poolmanagerPoolCreationFee := poolmanagerKeeper.GetParams(ctx).PoolCreationFee
	suite.Require().Equal(gammPoolCreationFee, poolmanagerPoolCreationFee)
}