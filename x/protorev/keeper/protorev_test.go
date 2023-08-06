package keeper_test

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/merlinslair/merlin/v16/x/protorev/types"
)

// TestGetTokenPairArbRoutes tests the GetTokenPairArbRoutes function.
func (s *KeeperTestSuite) TestGetTokenPairArbRoutes() {
	// Tests that we can properly retrieve all of the routes that were set up
	for _, tokenPair := range s.tokenPairArbRoutes {
		tokenPairArbRoutes, err := s.App.ProtoRevKeeper.GetTokenPairArbRoutes(s.Ctx, tokenPair.TokenIn, tokenPair.TokenOut)

		s.Require().NoError(err)
		s.Require().Equal(tokenPair, tokenPairArbRoutes)
	}

	// Testing to see if we will not find a route that does not exist
	_, err := s.App.ProtoRevKeeper.GetTokenPairArbRoutes(s.Ctx, "fury", "abc")
	s.Require().Error(err)
}

// TestGetAllTokenPairArbRoutes tests the GetAllTokenPairArbRoutes function.
func (s *KeeperTestSuite) TestGetAllTokenPairArbRoutes() {
	// Tests that we can properly retrieve all of the routes that were set up
	tokenPairArbRoutes, err := s.App.ProtoRevKeeper.GetAllTokenPairArbRoutes(s.Ctx)

	s.Require().NoError(err)

	s.Require().Equal(len(s.tokenPairArbRoutes), len(tokenPairArbRoutes))
	for _, tokenPair := range s.tokenPairArbRoutes {
		s.Require().Contains(tokenPairArbRoutes, tokenPair)
	}
}

// TestDeleteAllTokenPairArbRoutes tests the DeleteAllTokenPairArbRoutes function.
func (s *KeeperTestSuite) TestDeleteAllTokenPairArbRoutes() {
	// Tests that we can properly retrieve all of the routes that were set up
	tokenPairArbRoutes, err := s.App.ProtoRevKeeper.GetAllTokenPairArbRoutes(s.Ctx)

	s.Require().NoError(err)
	s.Require().Equal(len(s.tokenPairArbRoutes), len(tokenPairArbRoutes))
	for _, tokenPair := range s.tokenPairArbRoutes {
		s.Require().Contains(tokenPairArbRoutes, tokenPair)
	}

	// Delete all routes
	s.App.ProtoRevKeeper.DeleteAllTokenPairArbRoutes(s.Ctx)

	// Test after deletion
	tokenPairArbRoutes, err = s.App.ProtoRevKeeper.GetAllTokenPairArbRoutes(s.Ctx)

	s.Require().NoError(err)
	s.Require().Equal(0, len(tokenPairArbRoutes))
}

// TestGetAllBaseDenoms tests the GetAllBaseDenoms, SetBaseDenoms, and DeleteBaseDenoms functions.
func (s *KeeperTestSuite) TestGetAllBaseDenoms() {
	// Should be initialized on genesis
	baseDenoms, err := s.App.ProtoRevKeeper.GetAllBaseDenoms(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(3, len(baseDenoms))
	s.Require().Equal(baseDenoms[0].Denom, types.MerlinDenomination)
	s.Require().Equal(baseDenoms[1].Denom, "Atom")
	s.Require().Equal(baseDenoms[2].Denom, "test/3")

	// Should be able to delete all base denoms
	s.App.ProtoRevKeeper.DeleteBaseDenoms(s.Ctx)
	baseDenoms, err = s.App.ProtoRevKeeper.GetAllBaseDenoms(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(0, len(baseDenoms))

	// Should be able to set the base denoms
	err = s.App.ProtoRevKeeper.SetBaseDenoms(s.Ctx, []types.BaseDenom{{Denom: "fury"}, {Denom: "atom"}, {Denom: "weth"}})
	s.Require().NoError(err)
	baseDenoms, err = s.App.ProtoRevKeeper.GetAllBaseDenoms(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(3, len(baseDenoms))
	s.Require().Equal(baseDenoms[0].Denom, "fury")
	s.Require().Equal(baseDenoms[1].Denom, "atom")
	s.Require().Equal(baseDenoms[2].Denom, "weth")
}

// TestGetPoolForDenomPair tests the GetPoolForDenomPair, SetPoolForDenomPair, and DeleteAllPoolsForBaseDenom functions.
func (s *KeeperTestSuite) TestGetPoolForDenomPair() {
	// Should be able to set a pool for a denom pair
	s.App.ProtoRevKeeper.SetPoolForDenomPair(s.Ctx, "Atom", types.MerlinDenomination, 1000)
	pool, err := s.App.ProtoRevKeeper.GetPoolForDenomPair(s.Ctx, "Atom", types.MerlinDenomination)
	s.Require().NoError(err)
	s.Require().Equal(uint64(1000), pool)

	// Should be able to add another pool for a denom pair
	s.App.ProtoRevKeeper.SetPoolForDenomPair(s.Ctx, "Atom", "weth", 2000)
	pool, err = s.App.ProtoRevKeeper.GetPoolForDenomPair(s.Ctx, "Atom", "weth")
	s.Require().NoError(err)
	s.Require().Equal(uint64(2000), pool)

	s.App.ProtoRevKeeper.SetPoolForDenomPair(s.Ctx, types.MerlinDenomination, "Atom", 3000)
	pool, err = s.App.ProtoRevKeeper.GetPoolForDenomPair(s.Ctx, types.MerlinDenomination, "Atom")
	s.Require().NoError(err)
	s.Require().Equal(uint64(3000), pool)

	// Should be able to delete all pools for a base denom
	s.App.ProtoRevKeeper.DeleteAllPoolsForBaseDenom(s.Ctx, "Atom")
	_, err = s.App.ProtoRevKeeper.GetPoolForDenomPair(s.Ctx, "Atom", types.MerlinDenomination)
	s.Require().Error(err)
	_, err = s.App.ProtoRevKeeper.GetPoolForDenomPair(s.Ctx, "Atom", "weth")
	s.Require().Error(err)

	// Other denoms should still exist
	pool, err = s.App.ProtoRevKeeper.GetPoolForDenomPair(s.Ctx, types.MerlinDenomination, "Atom")
	s.Require().NoError(err)
	s.Require().Equal(uint64(3000), pool)
}

// TestGetDaysSinceModuleGenesis tests the GetDaysSinceModuleGenesis and SetDaysSinceModuleGenesis functions.
func (s *KeeperTestSuite) TestGetDaysSinceModuleGenesis() {
	// Should be initialized to 0 on genesis
	daysSinceGenesis, err := s.App.ProtoRevKeeper.GetDaysSinceModuleGenesis(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(0), daysSinceGenesis)

	// Should be able to set the days since genesis
	s.App.ProtoRevKeeper.SetDaysSinceModuleGenesis(s.Ctx, 1)
	daysSinceGenesis, err = s.App.ProtoRevKeeper.GetDaysSinceModuleGenesis(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(1), daysSinceGenesis)
}

// TestGetDeveloperFees tests the GetDeveloperFees, SetDeveloperFees, and GetAllDeveloperFees functions.
func (s *KeeperTestSuite) TestGetDeveloperFees() {
	// Should be initialized to [] on genesis
	fees, err := s.App.ProtoRevKeeper.GetAllDeveloperFees(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(0, len(fees))

	// Should be no fury fees on genesis
	furyFees, err := s.App.ProtoRevKeeper.GetDeveloperFees(s.Ctx, types.MerlinDenomination)
	s.Require().Error(err)
	s.Require().Equal(sdk.Coin{}, furyFees)

	// Should be no atom fees on genesis
	atomFees, err := s.App.ProtoRevKeeper.GetDeveloperFees(s.Ctx, "Atom")
	s.Require().Error(err)
	s.Require().Equal(sdk.Coin{}, atomFees)

	// Should be able to set the fees
	err = s.App.ProtoRevKeeper.SetDeveloperFees(s.Ctx, sdk.NewCoin(types.MerlinDenomination, sdk.NewInt(100)))
	s.Require().NoError(err)
	err = s.App.ProtoRevKeeper.SetDeveloperFees(s.Ctx, sdk.NewCoin("Atom", sdk.NewInt(100)))
	s.Require().NoError(err)
	err = s.App.ProtoRevKeeper.SetDeveloperFees(s.Ctx, sdk.NewCoin("weth", sdk.NewInt(100)))
	s.Require().NoError(err)

	// Should be able to get the fees
	furyFees, err = s.App.ProtoRevKeeper.GetDeveloperFees(s.Ctx, types.MerlinDenomination)
	s.Require().NoError(err)
	s.Require().Equal(sdk.NewCoin(types.MerlinDenomination, sdk.NewInt(100)), furyFees)
	atomFees, err = s.App.ProtoRevKeeper.GetDeveloperFees(s.Ctx, "Atom")
	s.Require().NoError(err)
	s.Require().Equal(sdk.NewCoin("Atom", sdk.NewInt(100)), atomFees)
	wethFees, err := s.App.ProtoRevKeeper.GetDeveloperFees(s.Ctx, "weth")
	s.Require().NoError(err)
	s.Require().Equal(sdk.NewCoin("weth", sdk.NewInt(100)), wethFees)

	fees, err = s.App.ProtoRevKeeper.GetAllDeveloperFees(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(3, len(fees))
	s.Require().Contains(fees, furyFees)
	s.Require().Contains(fees, atomFees)
}

// TestDeleteDeveloperFees tests the DeleteDeveloperFees function.
func (s *KeeperTestSuite) TestDeleteDeveloperFees() {
	err := s.App.ProtoRevKeeper.SetDeveloperFees(s.Ctx, sdk.NewCoin(types.MerlinDenomination, sdk.NewInt(100)))
	s.Require().NoError(err)

	// Should be able to get the fees
	furyFees, err := s.App.ProtoRevKeeper.GetDeveloperFees(s.Ctx, types.MerlinDenomination)
	s.Require().NoError(err)
	s.Require().Equal(sdk.NewCoin(types.MerlinDenomination, sdk.NewInt(100)), furyFees)

	// Should be able to delete the fees
	s.App.ProtoRevKeeper.DeleteDeveloperFees(s.Ctx, types.MerlinDenomination)

	// Should be no fury fees after deletion
	furyFees, err = s.App.ProtoRevKeeper.GetDeveloperFees(s.Ctx, types.MerlinDenomination)
	s.Require().Error(err)
	s.Require().Equal(sdk.Coin{}, furyFees)
}

// TestGetProtoRevEnabled tests the GetProtoRevEnabled and SetProtoRevEnabled functions.
func (s *KeeperTestSuite) TestGetProtoRevEnabled() {
	// Should be initialized to true on genesis
	protoRevEnabled := s.App.ProtoRevKeeper.GetProtoRevEnabled(s.Ctx)
	s.Require().Equal(true, protoRevEnabled)

	// Should be able to set the protoRevEnabled
	s.App.ProtoRevKeeper.SetProtoRevEnabled(s.Ctx, false)
	protoRevEnabled = s.App.ProtoRevKeeper.GetProtoRevEnabled(s.Ctx)
	s.Require().Equal(false, protoRevEnabled)
}

// TestGetAdminAccount tests the GetAdminAccount and SetAdminAccount functions.
func (s *KeeperTestSuite) TestGetAdminAccount() {
	// Should be initialized (look at keeper_test.go)
	adminAccount := s.App.ProtoRevKeeper.GetAdminAccount(s.Ctx)
	s.Require().Equal(s.adminAccount, adminAccount)

	// Should be able to set the admin account
	s.App.ProtoRevKeeper.SetAdminAccount(s.Ctx, s.TestAccs[0])
	adminAccount = s.App.ProtoRevKeeper.GetAdminAccount(s.Ctx)
	s.Require().Equal(s.TestAccs[0], adminAccount)
}

// TestGetDeveloperAccount tests the GetDeveloperAccount and SetDeveloperAccount functions.
func (s *KeeperTestSuite) TestGetDeveloperAccount() {
	// Should be null on genesis
	developerAccount, err := s.App.ProtoRevKeeper.GetDeveloperAccount(s.Ctx)
	s.Require().Error(err)
	s.Require().Nil(developerAccount)

	// Should be able to set the developer account
	s.App.ProtoRevKeeper.SetDeveloperAccount(s.Ctx, s.TestAccs[0])
	developerAccount, err = s.App.ProtoRevKeeper.GetDeveloperAccount(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(s.TestAccs[0], developerAccount)
}

// TestGetMaxPointsPerTx tests the GetMaxPointsPerTx and SetMaxPointsPerTx functions.
func (s *KeeperTestSuite) TestGetMaxPointsPerTx() {
	// Should be initialized on genesis
	maxPoints, err := s.App.ProtoRevKeeper.GetMaxPointsPerTx(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(18), maxPoints)

	// Should be able to set the max points per tx
	err = s.App.ProtoRevKeeper.SetMaxPointsPerTx(s.Ctx, 4)
	s.Require().NoError(err)
	maxPoints, err = s.App.ProtoRevKeeper.GetMaxPointsPerTx(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(4), maxPoints)

	// Can only be set between 1 and types.MaxPoolPointsPerTx
	err = s.App.ProtoRevKeeper.SetMaxPointsPerTx(s.Ctx, 0)
	s.Require().Error(err)
	err = s.App.ProtoRevKeeper.SetMaxPointsPerTx(s.Ctx, types.MaxPoolPointsPerTx+1)
	s.Require().Error(err)
}

// TestGetPointCountForBlock tests the GetPointCountForBlock, IncrementPointCountForBlock and SetPointCountForBlock functions.
func (s *KeeperTestSuite) TestGetPointCountForBlock() {
	// Should be initialized to 0 on genesis
	pointCount, err := s.App.ProtoRevKeeper.GetPointCountForBlock(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(0), pointCount)

	// Should be able to set the point count
	s.App.ProtoRevKeeper.SetPointCountForBlock(s.Ctx, 4)
	pointCount, err = s.App.ProtoRevKeeper.GetPointCountForBlock(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(4), pointCount)

	// Should be able to increment the point count
	err = s.App.ProtoRevKeeper.IncrementPointCountForBlock(s.Ctx, 10)
	s.Require().NoError(err)
	pointCount, err = s.App.ProtoRevKeeper.GetPointCountForBlock(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(14), pointCount)
}

// TestGetLatestBlockHeight tests the GetLatestBlockHeight and SetLatestBlockHeight functions.
func (s *KeeperTestSuite) TestGetLatestBlockHeight() {
	// Should be initialized on genesis
	blockHeight, err := s.App.ProtoRevKeeper.GetLatestBlockHeight(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(1), blockHeight)

	// Should be able to set the blockHeight
	s.App.ProtoRevKeeper.SetLatestBlockHeight(s.Ctx, 4)
	blockHeight, err = s.App.ProtoRevKeeper.GetLatestBlockHeight(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(4), blockHeight)
}

// TestGetMaxPointsPerBlock tests the GetMaxPointsPerBlock and SetMaxPointsPerBlock functions.
func (s *KeeperTestSuite) TestGetMaxPointsPerBlock() {
	// Should be initialized on genesis
	maxPoints, err := s.App.ProtoRevKeeper.GetMaxPointsPerBlock(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(100), maxPoints)

	// Should be able to set the max points per block
	err = s.App.ProtoRevKeeper.SetMaxPointsPerBlock(s.Ctx, 4)
	s.Require().NoError(err)
	maxPoints, err = s.App.ProtoRevKeeper.GetMaxPointsPerBlock(s.Ctx)
	s.Require().NoError(err)
	s.Require().Equal(uint64(4), maxPoints)

	// Can only initialize between 1 and types.MaxPoolPointsPerBlock
	err = s.App.ProtoRevKeeper.SetMaxPointsPerBlock(s.Ctx, 0)
	s.Require().Error(err)
	err = s.App.ProtoRevKeeper.SetMaxPointsPerBlock(s.Ctx, types.MaxPoolPointsPerBlock+1)
	s.Require().Error(err)
}

// TestGetPoolWeights tests the GetPoolWeights and SetPoolWeights functions.
func (s *KeeperTestSuite) TestGetPoolWeights() {
	// Should be initialized on genesis
	poolWeights := s.App.ProtoRevKeeper.GetPoolWeights(s.Ctx)
	s.Require().Equal(types.PoolWeights{StableWeight: 5, BalancerWeight: 2, ConcentratedWeight: 2}, poolWeights)

	// Should be able to set the PoolWeights
	newRouteWeights := types.PoolWeights{
		StableWeight:       10,
		BalancerWeight:     2,
		ConcentratedWeight: 22,
	}

	s.App.ProtoRevKeeper.SetPoolWeights(s.Ctx, newRouteWeights)

	poolWeights = s.App.ProtoRevKeeper.GetPoolWeights(s.Ctx)
	s.Require().Equal(newRouteWeights, poolWeights)
}
