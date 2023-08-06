package cli

import (
	"github.com/spf13/cobra"

	"github.com/merlins-labs/merlin/v16/x/ibc-rate-limit/client/queryproto"
	"github.com/merlins-labs/merlin/v16/x/ibc-rate-limit/types"
	"github.com/osmosis-labs/osmosis/osmoutils/osmocli"
)

// GetQueryCmd returns the cli query commands for this module.
func GetQueryCmd() *cobra.Command {
	cmd := osmocli.QueryIndexCmd(types.ModuleName)

	cmd.AddCommand(
		osmocli.GetParams[*queryproto.ParamsRequest](
			types.ModuleName, queryproto.NewQueryClient),
	)

	return cmd
}
