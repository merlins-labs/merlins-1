package main

import (
	"os"

	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"

	merlin "github.com/merlins-labs/merlin/app"
	"github.com/merlins-labs/merlin/app/params"
	"github.com/merlins-labs/merlin/cmd/merlin/cmd"
)

func main() {
	params.SetAddressPrefixes()
	rootCmd, _ := cmd.NewRootCmd()
	if err := svrcmd.Execute(rootCmd, merlin.DefaultNodeHome); err != nil {
		os.Exit(1)
	}
}
