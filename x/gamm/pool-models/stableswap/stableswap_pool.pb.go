// Code generated by protoc-gen-gogo. DO NOT EDIT.
// source: merlin/gamm/pool-models/stableswap/stableswap_pool.proto

package stableswap

import (
	fmt "fmt"
	_ "github.com/cosmos/cosmos-proto"
	github_com_cosmos_cosmos_sdk_types "github.com/cosmos/cosmos-sdk/types"
	types "github.com/cosmos/cosmos-sdk/types"
	_ "github.com/cosmos/cosmos-sdk/types/tx/amino"
	_ "github.com/cosmos/cosmos-sdk/x/auth/types"
	_ "github.com/gogo/protobuf/gogoproto"
	proto "github.com/gogo/protobuf/proto"
	_ "github.com/gogo/protobuf/types"
	io "io"
	math "math"
	math_bits "math/bits"
)

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.GoGoProtoPackageIsVersion3 // please upgrade the proto package

// PoolParams defined the parameters that will be managed by the pool
// governance in the future. This params are not managed by the chain
// governance. Instead they will be managed by the token holders of the pool.
// The pool's token holders are specified in future_pool_governor.
type PoolParams struct {
	SwapFee github_com_cosmos_cosmos_sdk_types.Dec `protobuf:"bytes,1,opt,name=swap_fee,json=swapFee,proto3,customtype=github.com/cosmos/cosmos-sdk/types.Dec" json:"swap_fee" yaml:"swap_fee"`
	// N.B.: exit fee is disabled during pool creation in x/poolmanager. While old
	// pools can maintain a non-zero fee. No new pool can be created with non-zero
	// fee anymore
	ExitFee github_com_cosmos_cosmos_sdk_types.Dec `protobuf:"bytes,2,opt,name=exit_fee,json=exitFee,proto3,customtype=github.com/cosmos/cosmos-sdk/types.Dec" json:"exit_fee" yaml:"exit_fee"`
}

func (m *PoolParams) Reset()         { *m = PoolParams{} }
func (m *PoolParams) String() string { return proto.CompactTextString(m) }
func (*PoolParams) ProtoMessage()    {}
func (*PoolParams) Descriptor() ([]byte, []int) {
	return fileDescriptor_ae0f054436f9999a, []int{0}
}
func (m *PoolParams) XXX_Unmarshal(b []byte) error {
	return m.Unmarshal(b)
}
func (m *PoolParams) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	if deterministic {
		return xxx_messageInfo_PoolParams.Marshal(b, m, deterministic)
	} else {
		b = b[:cap(b)]
		n, err := m.MarshalToSizedBuffer(b)
		if err != nil {
			return nil, err
		}
		return b[:n], nil
	}
}
func (m *PoolParams) XXX_Merge(src proto.Message) {
	xxx_messageInfo_PoolParams.Merge(m, src)
}
func (m *PoolParams) XXX_Size() int {
	return m.Size()
}
func (m *PoolParams) XXX_DiscardUnknown() {
	xxx_messageInfo_PoolParams.DiscardUnknown(m)
}

var xxx_messageInfo_PoolParams proto.InternalMessageInfo

// Pool is the stableswap Pool struct
type Pool struct {
	Address    string     `protobuf:"bytes,1,opt,name=address,proto3" json:"address,omitempty" yaml:"address"`
	Id         uint64     `protobuf:"varint,2,opt,name=id,proto3" json:"id,omitempty"`
	PoolParams PoolParams `protobuf:"bytes,3,opt,name=pool_params,json=poolParams,proto3" json:"pool_params" yaml:"stableswap_pool_params"`
	// This string specifies who will govern the pool in the future.
	// Valid forms of this are:
	// {token name},{duration}
	// {duration}
	// where {token name} if specified is the token which determines the
	// governor, and if not specified is the LP token for this pool.duration is
	// a time specified as 0w,1w,2w, etc. which specifies how long the token
	// would need to be locked up to count in governance. 0w means no lockup.
	FuturePoolGovernor string `protobuf:"bytes,4,opt,name=future_pool_governor,json=futurePoolGovernor,proto3" json:"future_pool_governor,omitempty" yaml:"future_pool_governor"`
	// sum of all LP shares
	TotalShares types.Coin `protobuf:"bytes,5,opt,name=total_shares,json=totalShares,proto3" json:"total_shares" yaml:"total_shares"`
	// assets in the pool
	PoolLiquidity github_com_cosmos_cosmos_sdk_types.Coins `protobuf:"bytes,6,rep,name=pool_liquidity,json=poolLiquidity,proto3,castrepeated=github.com/cosmos/cosmos-sdk/types.Coins" json:"pool_liquidity"`
	// for calculation amognst assets with different precisions
	ScalingFactors []uint64 `protobuf:"varint,7,rep,packed,name=scaling_factors,json=scalingFactors,proto3" json:"scaling_factors,omitempty" yaml:"stableswap_scaling_factors"`
	// scaling_factor_controller is the address can adjust pool scaling factors
	ScalingFactorController string `protobuf:"bytes,8,opt,name=scaling_factor_controller,json=scalingFactorController,proto3" json:"scaling_factor_controller,omitempty" yaml:"scaling_factor_controller"`
}

func (m *Pool) Reset()      { *m = Pool{} }
func (*Pool) ProtoMessage() {}
func (*Pool) Descriptor() ([]byte, []int) {
	return fileDescriptor_ae0f054436f9999a, []int{1}
}
func (m *Pool) XXX_Unmarshal(b []byte) error {
	return m.Unmarshal(b)
}
func (m *Pool) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	if deterministic {
		return xxx_messageInfo_Pool.Marshal(b, m, deterministic)
	} else {
		b = b[:cap(b)]
		n, err := m.MarshalToSizedBuffer(b)
		if err != nil {
			return nil, err
		}
		return b[:n], nil
	}
}
func (m *Pool) XXX_Merge(src proto.Message) {
	xxx_messageInfo_Pool.Merge(m, src)
}
func (m *Pool) XXX_Size() int {
	return m.Size()
}
func (m *Pool) XXX_DiscardUnknown() {
	xxx_messageInfo_Pool.DiscardUnknown(m)
}

var xxx_messageInfo_Pool proto.InternalMessageInfo

func init() {
	proto.RegisterType((*PoolParams)(nil), "merlin.gamm.poolmodels.stableswap.v1beta1.PoolParams")
	proto.RegisterType((*Pool)(nil), "merlin.gamm.poolmodels.stableswap.v1beta1.Pool")
}

func init() {
	proto.RegisterFile("merlin/gamm/pool-models/stableswap/stableswap_pool.proto", fileDescriptor_ae0f054436f9999a)
}

var fileDescriptor_ae0f054436f9999a = []byte{
	// 676 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0xa4, 0x54, 0xcf, 0x4f, 0xd4, 0x4c,
	0x18, 0xde, 0xc2, 0xc2, 0xf2, 0x0d, 0xdf, 0xb7, 0xe4, 0xab, 0x24, 0x16, 0x88, 0x9d, 0xa5, 0x11,
	0xb2, 0x21, 0x6e, 0xeb, 0x6a, 0x42, 0x22, 0x37, 0x16, 0x83, 0x31, 0x31, 0x06, 0xcb, 0xc9, 0x1f,
	0xc9, 0x3a, 0x6d, 0x67, 0xcb, 0xc4, 0x76, 0xa7, 0x76, 0xa6, 0x08, 0x17, 0xcf, 0xc6, 0x93, 0x47,
	0x8f, 0x9c, 0x3d, 0x79, 0xf0, 0x8f, 0x20, 0x7a, 0xe1, 0x68, 0x3c, 0x54, 0x03, 0x07, 0xaf, 0x66,
	0xff, 0x02, 0x33, 0xd3, 0xd9, 0x5d, 0x16, 0x95, 0x90, 0x78, 0xd9, 0x9d, 0xf7, 0x7d, 0x9f, 0xf7,
	0x79, 0x7f, 0x3d, 0x29, 0xb8, 0x45, 0x59, 0x4c, 0x19, 0x61, 0x4e, 0x88, 0xe2, 0xd8, 0x49, 0x28,
	0x8d, 0x1a, 0x31, 0x0d, 0x70, 0xc4, 0x1c, 0xc6, 0x91, 0x17, 0x61, 0xf6, 0x02, 0x25, 0xa7, 0x9e,
	0x6d, 0x81, 0xb0, 0x93, 0x94, 0x72, 0xaa, 0xaf, 0xa8, 0x54, 0x5b, 0xa4, 0xda, 0x22, 0x50, 0x64,
	0xda, 0x43, 0xb8, 0xbd, 0xdb, 0xf4, 0x30, 0x47, 0xcd, 0xf9, 0x39, 0x5f, 0x82, 0xdb, 0x32, 0xd3,
	0x29, 0x8c, 0x82, 0x66, 0x7e, 0x36, 0xa4, 0x21, 0x2d, 0xfc, 0xe2, 0xa5, 0xbc, 0xff, 0xa3, 0x98,
	0x74, 0xa9, 0x23, 0x7f, 0x95, 0xcb, 0x0c, 0x29, 0x0d, 0x23, 0xec, 0x48, 0xcb, 0xcb, 0x3a, 0x4e,
	0x90, 0xa5, 0x88, 0x13, 0xda, 0x55, 0x71, 0x78, 0x36, 0xce, 0x49, 0x8c, 0x19, 0x47, 0x71, 0xd2,
	0x27, 0x28, 0xea, 0x3a, 0x28, 0xe3, 0x3b, 0x8e, 0xea, 0x4c, 0x1a, 0x67, 0xe2, 0x1e, 0x62, 0x78,
	0x10, 0xf7, 0x29, 0x51, 0x05, 0xac, 0x1f, 0x1a, 0x00, 0x5b, 0x94, 0x46, 0x5b, 0x28, 0x45, 0x31,
	0xd3, 0x9f, 0x80, 0x29, 0xb9, 0x92, 0x0e, 0xc6, 0x86, 0x56, 0xd3, 0xea, 0xff, 0xb4, 0xd6, 0x0f,
	0x73, 0x58, 0xfa, 0x92, 0xc3, 0xe5, 0x90, 0xf0, 0x9d, 0xcc, 0xb3, 0x7d, 0x1a, 0xab, 0x59, 0xd5,
	0x5f, 0x83, 0x05, 0xcf, 0x1c, 0xbe, 0x9f, 0x60, 0x66, 0xdf, 0xc6, 0x7e, 0x2f, 0x87, 0x33, 0xfb,
	0x28, 0x8e, 0xd6, 0xac, 0x3e, 0x8f, 0xe5, 0x56, 0xc4, 0x73, 0x13, 0x63, 0xc1, 0x8e, 0xf7, 0x08,
	0x97, 0xec, 0x63, 0x7f, 0xc7, 0xde, 0xe7, 0xb1, 0xdc, 0x8a, 0x78, 0x6e, 0x62, 0xbc, 0xb6, 0xfc,
	0xfa, 0xfb, 0xfb, 0x95, 0xc5, 0x91, 0xdb, 0x6f, 0x0f, 0xae, 0x36, 0x9c, 0xd1, 0xfa, 0x34, 0x01,
	0xca, 0xc2, 0xd4, 0xaf, 0x81, 0x0a, 0x0a, 0x82, 0x14, 0x33, 0xa6, 0x66, 0xd5, 0x7b, 0x39, 0xac,
	0x16, 0xfc, 0x2a, 0x60, 0xb9, 0x7d, 0x88, 0x5e, 0x05, 0x63, 0x24, 0x90, 0x6d, 0x97, 0xdd, 0x31,
	0x12, 0xe8, 0x2f, 0xc1, 0xb4, 0xd0, 0x47, 0x3b, 0x91, 0xac, 0xc6, 0x78, 0x4d, 0xab, 0x4f, 0xdf,
	0x58, 0xb5, 0x2f, 0x2e, 0x20, 0x7b, 0xd8, 0x53, 0x6b, 0x49, 0xec, 0xa1, 0x97, 0xc3, 0x2b, 0x6a,
	0x77, 0xa3, 0xe2, 0x54, 0x35, 0x2c, 0x17, 0x24, 0xc3, 0x53, 0x3d, 0x00, 0xb3, 0x9d, 0x8c, 0x67,
	0x29, 0x2e, 0x20, 0x21, 0xdd, 0xc5, 0x69, 0x97, 0xa6, 0x46, 0x59, 0x8e, 0x02, 0x7b, 0x39, 0x5c,
	0x28, 0xc8, 0x7e, 0x87, 0xb2, 0x5c, 0xbd, 0x70, 0x8b, 0x1e, 0xee, 0x28, 0xa7, 0xfe, 0x10, 0xfc,
	0xcb, 0x29, 0x47, 0x51, 0x9b, 0xed, 0xa0, 0x14, 0x33, 0x63, 0x42, 0xce, 0x34, 0x67, 0x2b, 0x6d,
	0x0b, 0x0d, 0x0d, 0x9a, 0xdf, 0xa0, 0xa4, 0xdb, 0x5a, 0x50, 0x6d, 0x5f, 0x2a, 0x2a, 0x9d, 0x4e,
	0xb6, 0xdc, 0x69, 0x69, 0x6e, 0x4b, 0x4b, 0x4f, 0x41, 0x55, 0x36, 0x10, 0x91, 0xe7, 0x19, 0x09,
	0x08, 0xdf, 0x37, 0x26, 0x6b, 0xe3, 0xe7, 0x93, 0x5f, 0x17, 0xe4, 0xef, 0xbe, 0xc2, 0xfa, 0x05,
	0xb4, 0x21, 0x12, 0x98, 0xfb, 0x9f, 0x28, 0x71, 0xaf, 0x5f, 0x41, 0xbf, 0x0f, 0x66, 0x98, 0x8f,
	0x22, 0xd2, 0x0d, 0xdb, 0x1d, 0xe4, 0x73, 0x9a, 0x32, 0xa3, 0x52, 0x1b, 0xaf, 0x97, 0x5b, 0x4b,
	0xbd, 0x1c, 0x2e, 0xfe, 0xb2, 0xe9, 0x33, 0x58, 0xcb, 0xad, 0x2a, 0xcf, 0x66, 0xe1, 0xd0, 0x9f,
	0x82, 0xb9, 0x51, 0x4c, 0xdb, 0xa7, 0x5d, 0x9e, 0xd2, 0x28, 0xc2, 0xa9, 0x31, 0x25, 0xd7, 0x7e,
	0xb5, 0x97, 0xc3, 0x9a, 0x62, 0xfe, 0x13, 0xd4, 0x72, 0x2f, 0x8f, 0x10, 0x6f, 0x0c, 0x22, 0x6b,
	0xcd, 0x57, 0x07, 0xb0, 0xf4, 0xf6, 0x00, 0x96, 0x3e, 0x7e, 0x68, 0x4c, 0x88, 0xd3, 0xdc, 0x15,
	0x9a, 0x5e, 0x38, 0x47, 0xd3, 0xad, 0xc7, 0x87, 0xc7, 0xa6, 0x76, 0x74, 0x6c, 0x6a, 0xdf, 0x8e,
	0x4d, 0xed, 0xcd, 0x89, 0x59, 0x3a, 0x3a, 0x31, 0x4b, 0x9f, 0x4f, 0xcc, 0xd2, 0xa3, 0xf5, 0x53,
	0x7b, 0x53, 0x0c, 0x8d, 0x08, 0x79, 0xac, 0x6f, 0x38, 0xbb, 0xcd, 0x55, 0x67, 0xef, 0xbc, 0x8f,
	0xa4, 0x37, 0x29, 0x3f, 0x12, 0x37, 0x7f, 0x06, 0x00, 0x00, 0xff, 0xff, 0xce, 0x87, 0x39, 0xee,
	0x52, 0x05, 0x00, 0x00,
}

func (m *PoolParams) Marshal() (dAtA []byte, err error) {
	size := m.Size()
	dAtA = make([]byte, size)
	n, err := m.MarshalToSizedBuffer(dAtA[:size])
	if err != nil {
		return nil, err
	}
	return dAtA[:n], nil
}

func (m *PoolParams) MarshalTo(dAtA []byte) (int, error) {
	size := m.Size()
	return m.MarshalToSizedBuffer(dAtA[:size])
}

func (m *PoolParams) MarshalToSizedBuffer(dAtA []byte) (int, error) {
	i := len(dAtA)
	_ = i
	var l int
	_ = l
	{
		size := m.ExitFee.Size()
		i -= size
		if _, err := m.ExitFee.MarshalTo(dAtA[i:]); err != nil {
			return 0, err
		}
		i = encodeVarintStableswapPool(dAtA, i, uint64(size))
	}
	i--
	dAtA[i] = 0x12
	{
		size := m.SwapFee.Size()
		i -= size
		if _, err := m.SwapFee.MarshalTo(dAtA[i:]); err != nil {
			return 0, err
		}
		i = encodeVarintStableswapPool(dAtA, i, uint64(size))
	}
	i--
	dAtA[i] = 0xa
	return len(dAtA) - i, nil
}

func (m *Pool) Marshal() (dAtA []byte, err error) {
	size := m.Size()
	dAtA = make([]byte, size)
	n, err := m.MarshalToSizedBuffer(dAtA[:size])
	if err != nil {
		return nil, err
	}
	return dAtA[:n], nil
}

func (m *Pool) MarshalTo(dAtA []byte) (int, error) {
	size := m.Size()
	return m.MarshalToSizedBuffer(dAtA[:size])
}

func (m *Pool) MarshalToSizedBuffer(dAtA []byte) (int, error) {
	i := len(dAtA)
	_ = i
	var l int
	_ = l
	if len(m.ScalingFactorController) > 0 {
		i -= len(m.ScalingFactorController)
		copy(dAtA[i:], m.ScalingFactorController)
		i = encodeVarintStableswapPool(dAtA, i, uint64(len(m.ScalingFactorController)))
		i--
		dAtA[i] = 0x42
	}
	if len(m.ScalingFactors) > 0 {
		dAtA2 := make([]byte, len(m.ScalingFactors)*10)
		var j1 int
		for _, num := range m.ScalingFactors {
			for num >= 1<<7 {
				dAtA2[j1] = uint8(uint64(num)&0x7f | 0x80)
				num >>= 7
				j1++
			}
			dAtA2[j1] = uint8(num)
			j1++
		}
		i -= j1
		copy(dAtA[i:], dAtA2[:j1])
		i = encodeVarintStableswapPool(dAtA, i, uint64(j1))
		i--
		dAtA[i] = 0x3a
	}
	if len(m.PoolLiquidity) > 0 {
		for iNdEx := len(m.PoolLiquidity) - 1; iNdEx >= 0; iNdEx-- {
			{
				size, err := m.PoolLiquidity[iNdEx].MarshalToSizedBuffer(dAtA[:i])
				if err != nil {
					return 0, err
				}
				i -= size
				i = encodeVarintStableswapPool(dAtA, i, uint64(size))
			}
			i--
			dAtA[i] = 0x32
		}
	}
	{
		size, err := m.TotalShares.MarshalToSizedBuffer(dAtA[:i])
		if err != nil {
			return 0, err
		}
		i -= size
		i = encodeVarintStableswapPool(dAtA, i, uint64(size))
	}
	i--
	dAtA[i] = 0x2a
	if len(m.FuturePoolGovernor) > 0 {
		i -= len(m.FuturePoolGovernor)
		copy(dAtA[i:], m.FuturePoolGovernor)
		i = encodeVarintStableswapPool(dAtA, i, uint64(len(m.FuturePoolGovernor)))
		i--
		dAtA[i] = 0x22
	}
	{
		size, err := m.PoolParams.MarshalToSizedBuffer(dAtA[:i])
		if err != nil {
			return 0, err
		}
		i -= size
		i = encodeVarintStableswapPool(dAtA, i, uint64(size))
	}
	i--
	dAtA[i] = 0x1a
	if m.Id != 0 {
		i = encodeVarintStableswapPool(dAtA, i, uint64(m.Id))
		i--
		dAtA[i] = 0x10
	}
	if len(m.Address) > 0 {
		i -= len(m.Address)
		copy(dAtA[i:], m.Address)
		i = encodeVarintStableswapPool(dAtA, i, uint64(len(m.Address)))
		i--
		dAtA[i] = 0xa
	}
	return len(dAtA) - i, nil
}

func encodeVarintStableswapPool(dAtA []byte, offset int, v uint64) int {
	offset -= sovStableswapPool(v)
	base := offset
	for v >= 1<<7 {
		dAtA[offset] = uint8(v&0x7f | 0x80)
		v >>= 7
		offset++
	}
	dAtA[offset] = uint8(v)
	return base
}
func (m *PoolParams) Size() (n int) {
	if m == nil {
		return 0
	}
	var l int
	_ = l
	l = m.SwapFee.Size()
	n += 1 + l + sovStableswapPool(uint64(l))
	l = m.ExitFee.Size()
	n += 1 + l + sovStableswapPool(uint64(l))
	return n
}

func (m *Pool) Size() (n int) {
	if m == nil {
		return 0
	}
	var l int
	_ = l
	l = len(m.Address)
	if l > 0 {
		n += 1 + l + sovStableswapPool(uint64(l))
	}
	if m.Id != 0 {
		n += 1 + sovStableswapPool(uint64(m.Id))
	}
	l = m.PoolParams.Size()
	n += 1 + l + sovStableswapPool(uint64(l))
	l = len(m.FuturePoolGovernor)
	if l > 0 {
		n += 1 + l + sovStableswapPool(uint64(l))
	}
	l = m.TotalShares.Size()
	n += 1 + l + sovStableswapPool(uint64(l))
	if len(m.PoolLiquidity) > 0 {
		for _, e := range m.PoolLiquidity {
			l = e.Size()
			n += 1 + l + sovStableswapPool(uint64(l))
		}
	}
	if len(m.ScalingFactors) > 0 {
		l = 0
		for _, e := range m.ScalingFactors {
			l += sovStableswapPool(uint64(e))
		}
		n += 1 + sovStableswapPool(uint64(l)) + l
	}
	l = len(m.ScalingFactorController)
	if l > 0 {
		n += 1 + l + sovStableswapPool(uint64(l))
	}
	return n
}

func sovStableswapPool(x uint64) (n int) {
	return (math_bits.Len64(x|1) + 6) / 7
}
func sozStableswapPool(x uint64) (n int) {
	return sovStableswapPool(uint64((x << 1) ^ uint64((int64(x) >> 63))))
}
func (m *PoolParams) Unmarshal(dAtA []byte) error {
	l := len(dAtA)
	iNdEx := 0
	for iNdEx < l {
		preIndex := iNdEx
		var wire uint64
		for shift := uint(0); ; shift += 7 {
			if shift >= 64 {
				return ErrIntOverflowStableswapPool
			}
			if iNdEx >= l {
				return io.ErrUnexpectedEOF
			}
			b := dAtA[iNdEx]
			iNdEx++
			wire |= uint64(b&0x7F) << shift
			if b < 0x80 {
				break
			}
		}
		fieldNum := int32(wire >> 3)
		wireType := int(wire & 0x7)
		if wireType == 4 {
			return fmt.Errorf("proto: PoolParams: wiretype end group for non-group")
		}
		if fieldNum <= 0 {
			return fmt.Errorf("proto: PoolParams: illegal tag %d (wire type %d)", fieldNum, wire)
		}
		switch fieldNum {
		case 1:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field SwapFee", wireType)
			}
			var stringLen uint64
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				stringLen |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			intStringLen := int(stringLen)
			if intStringLen < 0 {
				return ErrInvalidLengthStableswapPool
			}
			postIndex := iNdEx + intStringLen
			if postIndex < 0 {
				return ErrInvalidLengthStableswapPool
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			if err := m.SwapFee.Unmarshal(dAtA[iNdEx:postIndex]); err != nil {
				return err
			}
			iNdEx = postIndex
		case 2:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field ExitFee", wireType)
			}
			var stringLen uint64
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				stringLen |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			intStringLen := int(stringLen)
			if intStringLen < 0 {
				return ErrInvalidLengthStableswapPool
			}
			postIndex := iNdEx + intStringLen
			if postIndex < 0 {
				return ErrInvalidLengthStableswapPool
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			if err := m.ExitFee.Unmarshal(dAtA[iNdEx:postIndex]); err != nil {
				return err
			}
			iNdEx = postIndex
		default:
			iNdEx = preIndex
			skippy, err := skipStableswapPool(dAtA[iNdEx:])
			if err != nil {
				return err
			}
			if (skippy < 0) || (iNdEx+skippy) < 0 {
				return ErrInvalidLengthStableswapPool
			}
			if (iNdEx + skippy) > l {
				return io.ErrUnexpectedEOF
			}
			iNdEx += skippy
		}
	}

	if iNdEx > l {
		return io.ErrUnexpectedEOF
	}
	return nil
}
func (m *Pool) Unmarshal(dAtA []byte) error {
	l := len(dAtA)
	iNdEx := 0
	for iNdEx < l {
		preIndex := iNdEx
		var wire uint64
		for shift := uint(0); ; shift += 7 {
			if shift >= 64 {
				return ErrIntOverflowStableswapPool
			}
			if iNdEx >= l {
				return io.ErrUnexpectedEOF
			}
			b := dAtA[iNdEx]
			iNdEx++
			wire |= uint64(b&0x7F) << shift
			if b < 0x80 {
				break
			}
		}
		fieldNum := int32(wire >> 3)
		wireType := int(wire & 0x7)
		if wireType == 4 {
			return fmt.Errorf("proto: Pool: wiretype end group for non-group")
		}
		if fieldNum <= 0 {
			return fmt.Errorf("proto: Pool: illegal tag %d (wire type %d)", fieldNum, wire)
		}
		switch fieldNum {
		case 1:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field Address", wireType)
			}
			var stringLen uint64
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				stringLen |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			intStringLen := int(stringLen)
			if intStringLen < 0 {
				return ErrInvalidLengthStableswapPool
			}
			postIndex := iNdEx + intStringLen
			if postIndex < 0 {
				return ErrInvalidLengthStableswapPool
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			m.Address = string(dAtA[iNdEx:postIndex])
			iNdEx = postIndex
		case 2:
			if wireType != 0 {
				return fmt.Errorf("proto: wrong wireType = %d for field Id", wireType)
			}
			m.Id = 0
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				m.Id |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
		case 3:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field PoolParams", wireType)
			}
			var msglen int
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				msglen |= int(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			if msglen < 0 {
				return ErrInvalidLengthStableswapPool
			}
			postIndex := iNdEx + msglen
			if postIndex < 0 {
				return ErrInvalidLengthStableswapPool
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			if err := m.PoolParams.Unmarshal(dAtA[iNdEx:postIndex]); err != nil {
				return err
			}
			iNdEx = postIndex
		case 4:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field FuturePoolGovernor", wireType)
			}
			var stringLen uint64
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				stringLen |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			intStringLen := int(stringLen)
			if intStringLen < 0 {
				return ErrInvalidLengthStableswapPool
			}
			postIndex := iNdEx + intStringLen
			if postIndex < 0 {
				return ErrInvalidLengthStableswapPool
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			m.FuturePoolGovernor = string(dAtA[iNdEx:postIndex])
			iNdEx = postIndex
		case 5:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field TotalShares", wireType)
			}
			var msglen int
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				msglen |= int(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			if msglen < 0 {
				return ErrInvalidLengthStableswapPool
			}
			postIndex := iNdEx + msglen
			if postIndex < 0 {
				return ErrInvalidLengthStableswapPool
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			if err := m.TotalShares.Unmarshal(dAtA[iNdEx:postIndex]); err != nil {
				return err
			}
			iNdEx = postIndex
		case 6:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field PoolLiquidity", wireType)
			}
			var msglen int
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				msglen |= int(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			if msglen < 0 {
				return ErrInvalidLengthStableswapPool
			}
			postIndex := iNdEx + msglen
			if postIndex < 0 {
				return ErrInvalidLengthStableswapPool
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			m.PoolLiquidity = append(m.PoolLiquidity, types.Coin{})
			if err := m.PoolLiquidity[len(m.PoolLiquidity)-1].Unmarshal(dAtA[iNdEx:postIndex]); err != nil {
				return err
			}
			iNdEx = postIndex
		case 7:
			if wireType == 0 {
				var v uint64
				for shift := uint(0); ; shift += 7 {
					if shift >= 64 {
						return ErrIntOverflowStableswapPool
					}
					if iNdEx >= l {
						return io.ErrUnexpectedEOF
					}
					b := dAtA[iNdEx]
					iNdEx++
					v |= uint64(b&0x7F) << shift
					if b < 0x80 {
						break
					}
				}
				m.ScalingFactors = append(m.ScalingFactors, v)
			} else if wireType == 2 {
				var packedLen int
				for shift := uint(0); ; shift += 7 {
					if shift >= 64 {
						return ErrIntOverflowStableswapPool
					}
					if iNdEx >= l {
						return io.ErrUnexpectedEOF
					}
					b := dAtA[iNdEx]
					iNdEx++
					packedLen |= int(b&0x7F) << shift
					if b < 0x80 {
						break
					}
				}
				if packedLen < 0 {
					return ErrInvalidLengthStableswapPool
				}
				postIndex := iNdEx + packedLen
				if postIndex < 0 {
					return ErrInvalidLengthStableswapPool
				}
				if postIndex > l {
					return io.ErrUnexpectedEOF
				}
				var elementCount int
				var count int
				for _, integer := range dAtA[iNdEx:postIndex] {
					if integer < 128 {
						count++
					}
				}
				elementCount = count
				if elementCount != 0 && len(m.ScalingFactors) == 0 {
					m.ScalingFactors = make([]uint64, 0, elementCount)
				}
				for iNdEx < postIndex {
					var v uint64
					for shift := uint(0); ; shift += 7 {
						if shift >= 64 {
							return ErrIntOverflowStableswapPool
						}
						if iNdEx >= l {
							return io.ErrUnexpectedEOF
						}
						b := dAtA[iNdEx]
						iNdEx++
						v |= uint64(b&0x7F) << shift
						if b < 0x80 {
							break
						}
					}
					m.ScalingFactors = append(m.ScalingFactors, v)
				}
			} else {
				return fmt.Errorf("proto: wrong wireType = %d for field ScalingFactors", wireType)
			}
		case 8:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field ScalingFactorController", wireType)
			}
			var stringLen uint64
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				stringLen |= uint64(b&0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			intStringLen := int(stringLen)
			if intStringLen < 0 {
				return ErrInvalidLengthStableswapPool
			}
			postIndex := iNdEx + intStringLen
			if postIndex < 0 {
				return ErrInvalidLengthStableswapPool
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			m.ScalingFactorController = string(dAtA[iNdEx:postIndex])
			iNdEx = postIndex
		default:
			iNdEx = preIndex
			skippy, err := skipStableswapPool(dAtA[iNdEx:])
			if err != nil {
				return err
			}
			if (skippy < 0) || (iNdEx+skippy) < 0 {
				return ErrInvalidLengthStableswapPool
			}
			if (iNdEx + skippy) > l {
				return io.ErrUnexpectedEOF
			}
			iNdEx += skippy
		}
	}

	if iNdEx > l {
		return io.ErrUnexpectedEOF
	}
	return nil
}
func skipStableswapPool(dAtA []byte) (n int, err error) {
	l := len(dAtA)
	iNdEx := 0
	depth := 0
	for iNdEx < l {
		var wire uint64
		for shift := uint(0); ; shift += 7 {
			if shift >= 64 {
				return 0, ErrIntOverflowStableswapPool
			}
			if iNdEx >= l {
				return 0, io.ErrUnexpectedEOF
			}
			b := dAtA[iNdEx]
			iNdEx++
			wire |= (uint64(b) & 0x7F) << shift
			if b < 0x80 {
				break
			}
		}
		wireType := int(wire & 0x7)
		switch wireType {
		case 0:
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return 0, ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return 0, io.ErrUnexpectedEOF
				}
				iNdEx++
				if dAtA[iNdEx-1] < 0x80 {
					break
				}
			}
		case 1:
			iNdEx += 8
		case 2:
			var length int
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return 0, ErrIntOverflowStableswapPool
				}
				if iNdEx >= l {
					return 0, io.ErrUnexpectedEOF
				}
				b := dAtA[iNdEx]
				iNdEx++
				length |= (int(b) & 0x7F) << shift
				if b < 0x80 {
					break
				}
			}
			if length < 0 {
				return 0, ErrInvalidLengthStableswapPool
			}
			iNdEx += length
		case 3:
			depth++
		case 4:
			if depth == 0 {
				return 0, ErrUnexpectedEndOfGroupStableswapPool
			}
			depth--
		case 5:
			iNdEx += 4
		default:
			return 0, fmt.Errorf("proto: illegal wireType %d", wireType)
		}
		if iNdEx < 0 {
			return 0, ErrInvalidLengthStableswapPool
		}
		if depth == 0 {
			return iNdEx, nil
		}
	}
	return 0, io.ErrUnexpectedEOF
}

var (
	ErrInvalidLengthStableswapPool        = fmt.Errorf("proto: negative length found during unmarshaling")
	ErrIntOverflowStableswapPool          = fmt.Errorf("proto: integer overflow")
	ErrUnexpectedEndOfGroupStableswapPool = fmt.Errorf("proto: unexpected end of group")
)
