package keeper_test

import (
	cltypes "github.com/merlins-labs/merlin/x/concentrated-liquidity/types"
	"github.com/merlins-labs/merlin/x/superfluid/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (s *KeeperTestSuite) TestMerEquivalentMultiplierSetGetDeleteFlow() {
	s.SetupTest()

	// initial check
	multipliers := s.App.SuperfluidKeeper.GetAllMerEquivalentMultipliers(s.Ctx)
	s.Require().Len(multipliers, 0)

	// set multiplier
	s.App.SuperfluidKeeper.SetMerEquivalentMultiplier(s.Ctx, 1, DefaultGammAsset, sdk.NewDec(2))

	// get multiplier
	multiplier := s.App.SuperfluidKeeper.GetMerEquivalentMultiplier(s.Ctx, DefaultGammAsset)
	s.Require().Equal(multiplier, sdk.NewDec(2))

	// check multipliers
	expectedMultipliers := []types.MerEquivalentMultiplierRecord{
		{
			EpochNumber: 1,
			Denom:       DefaultGammAsset,
			Multiplier:  sdk.NewDec(2),
		},
	}
	multipliers = s.App.SuperfluidKeeper.GetAllMerEquivalentMultipliers(s.Ctx)
	s.Require().Equal(multipliers, expectedMultipliers)

	// test last epoch price
	multiplier = s.App.SuperfluidKeeper.GetMerEquivalentMultiplier(s.Ctx, DefaultGammAsset)
	s.Require().Equal(multiplier, sdk.NewDec(2))

	// delete multiplier
	s.App.SuperfluidKeeper.DeleteMerEquivalentMultiplier(s.Ctx, DefaultGammAsset)

	// get multiplier
	multiplier = s.App.SuperfluidKeeper.GetMerEquivalentMultiplier(s.Ctx, DefaultGammAsset)
	s.Require().Equal(multiplier, sdk.NewDec(0))

	// check multipliers
	multipliers = s.App.SuperfluidKeeper.GetAllMerEquivalentMultipliers(s.Ctx)
	s.Require().Len(multipliers, 0)

	// test last epoch price
	multiplier = s.App.SuperfluidKeeper.GetMerEquivalentMultiplier(s.Ctx, DefaultGammAsset)
	s.Require().Equal(multiplier, sdk.NewDec(0))
}

func (s *KeeperTestSuite) TestGetSuperfluidMERTokens() {
	s.SetupTest()
	minRiskFactor := s.App.SuperfluidKeeper.GetParams(s.Ctx).MinimumRiskFactor
	poolCoins := sdk.NewCoins(sdk.NewCoin("stake", sdk.NewInt(1000000000000000000)), sdk.NewCoin("foo", sdk.NewInt(1000000000000000000)))
	s.PrepareBalancerPoolWithCoins(poolCoins...)
	s.PrepareConcentratedPoolWithCoinsAndFullRangePosition("stake", "foo")

	gammShareDenom := DefaultGammAsset
	clShareDenom := cltypes.GetConcentratedLockupDenomFromPoolId(2)

	multiplier := sdk.NewDec(2)
	testAmount := sdk.NewInt(100)
	epoch := int64(1)

	// Set multiplier
	s.App.SuperfluidKeeper.SetMerEquivalentMultiplier(s.Ctx, epoch, gammShareDenom, multiplier)

	// Get multiplier
	multiplier = s.App.SuperfluidKeeper.GetMerEquivalentMultiplier(s.Ctx, gammShareDenom)
	s.Require().Equal(multiplier, sdk.NewDec(2))

	// Should get error since asset is not superfluid enabled
	merTokens, err := s.App.SuperfluidKeeper.GetSuperfluidMERTokens(s.Ctx, gammShareDenom, testAmount)
	s.Require().Error(err)
	s.Require().ErrorIs(err, types.ErrNonSuperfluidAsset)
	s.Require().Equal(merTokens, sdk.NewInt(0))

	// Set gamm share as superfluid
	superfluidGammAsset := types.SuperfluidAsset{
		Denom:     gammShareDenom,
		AssetType: types.SuperfluidAssetTypeLPShare,
	}
	err = s.App.SuperfluidKeeper.AddNewSuperfluidAsset(s.Ctx, superfluidGammAsset)
	s.Require().NoError(err)

	// Reset multiplier
	s.App.SuperfluidKeeper.SetMerEquivalentMultiplier(s.Ctx, epoch, gammShareDenom, multiplier)

	// Get superfluid MER tokens
	merTokens, err = s.App.SuperfluidKeeper.GetSuperfluidMERTokens(s.Ctx, gammShareDenom, testAmount)
	s.Require().NoError(err)

	// Adjust result with risk factor
	merTokensRiskAdjusted := s.App.SuperfluidKeeper.GetRiskAdjustedMerValue(s.Ctx, merTokens)

	// Check result
	s.Require().Equal(testAmount.ToDec().Mul(minRiskFactor).TruncateInt().String(), merTokensRiskAdjusted.String())

	// Set cl share as superfluid
	superfluidClAsset := types.SuperfluidAsset{
		Denom:     clShareDenom,
		AssetType: types.SuperfluidAssetTypeConcentratedShare,
	}
	err = s.App.SuperfluidKeeper.AddNewSuperfluidAsset(s.Ctx, superfluidClAsset)
	s.Require().NoError(err)

	// Reset multiplier
	s.App.SuperfluidKeeper.SetMerEquivalentMultiplier(s.Ctx, epoch, clShareDenom, multiplier)

	// Get superfluid MER tokens
	merTokens, err = s.App.SuperfluidKeeper.GetSuperfluidMERTokens(s.Ctx, clShareDenom, testAmount)
	s.Require().NoError(err)

	// Adjust result with risk factor
	merTokensRiskAdjusted = s.App.SuperfluidKeeper.GetRiskAdjustedMerValue(s.Ctx, merTokens)

	// Check result
	s.Require().Equal(testAmount.ToDec().Mul(minRiskFactor).TruncateInt().String(), merTokensRiskAdjusted.String())
}
