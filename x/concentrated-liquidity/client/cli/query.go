package cli

import (
	"github.com/spf13/cobra"
	flag "github.com/spf13/pflag"

	"github.com/merlins-labs/merlin/x/concentrated-liquidity/client/queryproto"
	"github.com/merlins-labs/merlin/x/concentrated-liquidity/types"
	"github.com/osmosis-labs/osmosis/osmoutils/osmocli"
)

// GetQueryCmd returns the cli query commands for this module.
func GetQueryCmd() *cobra.Command {
	cmd := osmocli.QueryIndexCmd(types.ModuleName)
	osmocli.AddQueryCmd(cmd, queryproto.NewQueryClient, GetCmdPools)
	osmocli.AddQueryCmd(cmd, queryproto.NewQueryClient, GetUserPositions)
	osmocli.AddQueryCmd(cmd, queryproto.NewQueryClient, GetPositionById)
	osmocli.AddQueryCmd(cmd, queryproto.NewQueryClient, GetClaimableSpreadRewards)
	osmocli.AddQueryCmd(cmd, queryproto.NewQueryClient, GetClaimableIncentives)
	osmocli.AddQueryCmd(cmd, queryproto.NewQueryClient, GetIncentiveRecords)
	osmocli.AddQueryCmd(cmd, queryproto.NewQueryClient, GetCFMMPoolIdLinkFromConcentratedPoolId)
	cmd.AddCommand(
		osmocli.GetParams[*queryproto.ParamsRequest](
			types.ModuleName, queryproto.NewQueryClient),
	)
	return cmd
}

func GetUserPositions() (*osmocli.QueryDescriptor, *queryproto.UserPositionsRequest) {
	return &osmocli.QueryDescriptor{
			Use:   "user-positions [address]",
			Short: "Query user's positions",
			Long: `{{.Short}}{{.ExampleHeader}}
{{.CommandPrefix}} user-positions fury12smx2wdlyttvyzvzg54y2vnqwq2qjateuf7thj`,
			Flags:               osmocli.FlagDesc{OptionalFlags: []*flag.FlagSet{FlagSetJustPoolId()}},
			CustomFlagOverrides: poolIdFlagOverride,
		},
		&queryproto.UserPositionsRequest{}
}

func GetPositionById() (*osmocli.QueryDescriptor, *queryproto.PositionByIdRequest) {
	return &osmocli.QueryDescriptor{
			Use:   "position-by-id [positionID]",
			Short: "Query position by ID",
			Long: `{{.Short}}{{.ExampleHeader}}
{{.CommandPrefix}} position-by-id 53`,
		},
		&queryproto.PositionByIdRequest{}
}

func GetCmdPools() (*osmocli.QueryDescriptor, *queryproto.PoolsRequest) {
	return &osmocli.QueryDescriptor{
		Use:   "pools",
		Short: "Query pools",
		Long: `{{.Short}}{{.ExampleHeader}}
{{.CommandPrefix}} pools`,
	}, &queryproto.PoolsRequest{}
}

func GetClaimableSpreadRewards() (*osmocli.QueryDescriptor, *queryproto.ClaimableSpreadRewardsRequest) {
	return &osmocli.QueryDescriptor{
		Use:   "claimable-spread-rewards [positionID]",
		Short: "Query claimable spread rewards",
		Long: `{{.Short}}{{.ExampleHeader}}
{{.CommandPrefix}} claimable-spread-rewards 53`,
	}, &queryproto.ClaimableSpreadRewardsRequest{}
}

func GetClaimableIncentives() (*osmocli.QueryDescriptor, *queryproto.ClaimableIncentivesRequest) {
	return &osmocli.QueryDescriptor{
		Use:   "claimable-incentives [positionID]",
		Short: "Query claimable incentives",
		Long: `{{.Short}}{{.ExampleHeader}}
{{.CommandPrefix}} claimable-incentives 53`,
	}, &queryproto.ClaimableIncentivesRequest{}
}

func GetIncentiveRecords() (*osmocli.QueryDescriptor, *queryproto.IncentiveRecordsRequest) {
	return &osmocli.QueryDescriptor{
		Use:   "incentive-records [poolId]",
		Short: "Query incentive records for a given pool",
		Long: `{{.Short}}{{.ExampleHeader}}
{{.CommandPrefix}} incentive-records 1`,
	}, &queryproto.IncentiveRecordsRequest{}
}

func GetCFMMPoolIdLinkFromConcentratedPoolId() (*osmocli.QueryDescriptor, *queryproto.CFMMPoolIdLinkFromConcentratedPoolIdRequest) {
	return &osmocli.QueryDescriptor{
		Use:   "cfmm-pool-link-from-cl [poolId]",
		Short: "Query cfmm pool id link from concentrated pool id",
		Long: `{{.Short}}{{.ExampleHeader}}
{{.CommandPrefix}} cfmm-pool-link-from-cl 1`,
	}, &queryproto.CFMMPoolIdLinkFromConcentratedPoolIdRequest{}
}

func GetTotalLiquidity() (*osmocli.QueryDescriptor, *queryproto.GetTotalLiquidityRequest) {
	return &osmocli.QueryDescriptor{
		Use:   "total-liquidity",
		Short: "Query total liquidity across all concentrated pool",
		Long: `{{.Short}}{{.ExampleHeader}}
{{.CommandPrefix}} total-liquidity 1`,
	}, &queryproto.GetTotalLiquidityRequest{}
}
