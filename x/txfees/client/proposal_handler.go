package client

import (
	"github.com/merlinslair/merlin/v16/x/txfees/client/cli"
	"github.com/merlinslair/merlin/v16/x/txfees/client/rest"

	govclient "github.com/cosmos/cosmos-sdk/x/gov/client"
)

var (
	SubmitUpdateFeeTokenProposalHandler = govclient.NewProposalHandler(cli.NewCmdSubmitUpdateFeeTokenProposal, rest.ProposalUpdateFeeTokenProposalRESTHandler)
)
