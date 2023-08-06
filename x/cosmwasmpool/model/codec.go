package model

import (
	"github.com/cosmos/cosmos-sdk/codec"
	cdctypes "github.com/cosmos/cosmos-sdk/codec/types"
	authzcodec "github.com/cosmos/cosmos-sdk/x/authz/codec"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/msgservice"

	"github.com/merlins-labs/merlin/v16/x/cosmwasmpool/types"
	poolmanagertypes "github.com/merlins-labs/merlin/v16/x/poolmanager/types"
)

func RegisterCodec(cdc *codec.LegacyAmino) {
	cdc.RegisterConcrete(&CosmWasmPool{}, "merlin/cw-pool", nil)
	cdc.RegisterConcrete(&Pool{}, "merlin/cw-pool-wrap", nil)
	cdc.RegisterConcrete(&MsgCreateCosmWasmPool{}, "merlin/cw-create-pool", nil)
}

func RegisterInterfaces(registry cdctypes.InterfaceRegistry) {
	registry.RegisterInterface(
		"merlin.poolmanager.v1beta1.PoolI",
		(*poolmanagertypes.PoolI)(nil),
		&CosmWasmPool{},
	)
	registry.RegisterInterface(
		"merlin.cosmwasmpool.v1beta1.CosmWasmExtension",
		(*types.CosmWasmExtension)(nil),
		&CosmWasmPool{},
	)

	registry.RegisterImplementations(
		(*sdk.Msg)(nil),
		&MsgCreateCosmWasmPool{},
	)

	msgservice.RegisterMsgServiceDesc(registry, &_MsgCreator_serviceDesc)
}

var (
	amino     = codec.NewLegacyAmino()
	ModuleCdc = codec.NewAminoCodec(amino)
)

func init() {
	RegisterCodec(amino)
	sdk.RegisterLegacyAminoCodec(amino)

	// Register all Amino interfaces and concrete types on the authz Amino codec so that this can later be
	// used to properly serialize MsgGrant and MsgExec instances
	RegisterCodec(authzcodec.Amino)
	amino.Seal()
}
