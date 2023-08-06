package main

import (
	"os"

	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"

	merlin "github.com/merlins-labs/merlin/v16/app"
	"github.com/merlins-labs/merlin/v16/app/params"
	"github.com/merlins-labs/merlin/v16/cmd/merlin/cmd"
)

func main() {
	params.SetAddressPrefixes()
	rootCmd, _ := cmd.NewRootCmd()
	if err := svrcmd.Execute(rootCmd, merlin.DefaultNodeHome); err != nil {
		os.Exit(1)
	}
}
