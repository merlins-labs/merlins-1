package gov_test

import (
	"testing"

	"github.com/stretchr/testify/suite"

	"github.com/merlins-labs/merlin/app/apptesting"
	"github.com/merlins-labs/merlin/x/superfluid/keeper"
	"github.com/merlins-labs/merlin/x/superfluid/types"
)

type KeeperTestSuite struct {
	apptesting.KeeperTestHelper

	querier types.QueryServer
}

func (s *KeeperTestSuite) SetupTest() {
	s.Setup()
	s.querier = keeper.NewQuerier(*s.App.SuperfluidKeeper)
}

func TestKeeperTestSuite(t *testing.T) {
	suite.Run(t, new(KeeperTestSuite))
}
