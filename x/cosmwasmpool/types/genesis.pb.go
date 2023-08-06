// Code generated by protoc-gen-gogo. DO NOT EDIT.
// source: merlin/cosmwasmpool/v1beta1/genesis.proto

package types

import (
	fmt "fmt"
	_ "github.com/cosmos/cosmos-proto"
	types "github.com/cosmos/cosmos-sdk/codec/types"
	_ "github.com/cosmos/cosmos-sdk/types"
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

// GenesisState defines the cosmwasmpool module's genesis state.
type GenesisState struct {
	// params is the container of cosmwasmpool parameters.
	Params Params       `protobuf:"bytes,1,opt,name=params,proto3" json:"params"`
	Pools  []*types.Any `protobuf:"bytes,2,rep,name=pools,proto3" json:"pools,omitempty"`
}

func (m *GenesisState) Reset()         { *m = GenesisState{} }
func (m *GenesisState) String() string { return proto.CompactTextString(m) }
func (*GenesisState) ProtoMessage()    {}
func (*GenesisState) Descriptor() ([]byte, []int) {
	return fileDescriptor_8fd7fc7fdf8fd2f4, []int{0}
}
func (m *GenesisState) XXX_Unmarshal(b []byte) error {
	return m.Unmarshal(b)
}
func (m *GenesisState) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	if deterministic {
		return xxx_messageInfo_GenesisState.Marshal(b, m, deterministic)
	} else {
		b = b[:cap(b)]
		n, err := m.MarshalToSizedBuffer(b)
		if err != nil {
			return nil, err
		}
		return b[:n], nil
	}
}
func (m *GenesisState) XXX_Merge(src proto.Message) {
	xxx_messageInfo_GenesisState.Merge(m, src)
}
func (m *GenesisState) XXX_Size() int {
	return m.Size()
}
func (m *GenesisState) XXX_DiscardUnknown() {
	xxx_messageInfo_GenesisState.DiscardUnknown(m)
}

var xxx_messageInfo_GenesisState proto.InternalMessageInfo

func (m *GenesisState) GetParams() Params {
	if m != nil {
		return m.Params
	}
	return Params{}
}

func (m *GenesisState) GetPools() []*types.Any {
	if m != nil {
		return m.Pools
	}
	return nil
}

func init() {
	proto.RegisterType((*GenesisState)(nil), "merlin.cosmwasmpool.v1beta1.GenesisState")
}

func init() {
	proto.RegisterFile("merlin/cosmwasmpool/v1beta1/genesis.proto", fileDescriptor_8fd7fc7fdf8fd2f4)
}

var fileDescriptor_8fd7fc7fdf8fd2f4 = []byte{
	// 307 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0xff, 0x7c, 0x8f, 0xb1, 0x4e, 0xeb, 0x30,
	0x14, 0x86, 0xe3, 0x7b, 0x69, 0x25, 0x52, 0xa6, 0xaa, 0x43, 0xa9, 0x90, 0xa9, 0x10, 0x43, 0x41,
	0xaa, 0xad, 0x14, 0x81, 0x58, 0xc9, 0x82, 0xd8, 0xaa, 0xb0, 0xb1, 0x20, 0x3b, 0x18, 0x13, 0x29,
	0xc9, 0x89, 0x62, 0xa7, 0x90, 0x47, 0x60, 0xe3, 0x61, 0x78, 0x88, 0x8a, 0xa9, 0x23, 0x13, 0x42,
	0xc9, 0x8b, 0xa0, 0xc6, 0x0e, 0x02, 0x86, 0x6e, 0x3e, 0xfa, 0xbf, 0xdf, 0xe7, 0x7c, 0xee, 0x31,
	0xa8, 0x04, 0x54, 0xa4, 0x68, 0x08, 0x2a, 0x79, 0x64, 0x2a, 0xc9, 0x00, 0x62, 0xba, 0xf0, 0xb8,
	0xd0, 0xcc, 0xa3, 0x52, 0xa4, 0x42, 0x45, 0x8a, 0x64, 0x39, 0x68, 0xe8, 0xef, 0x59, 0x96, 0xfc,
	0x64, 0x89, 0x65, 0x47, 0x03, 0x09, 0x12, 0x1a, 0x90, 0xae, 0x5f, 0xa6, 0x33, 0xda, 0x95, 0x00,
	0x32, 0x16, 0xb4, 0x99, 0x78, 0x71, 0x4f, 0x59, 0x5a, 0xb6, 0x51, 0xd8, 0xfc, 0x77, 0x6b, 0x3a,
	0x66, 0xb0, 0x11, 0xfe, 0xdb, 0xba, 0x2b, 0x72, 0xa6, 0x23, 0x48, 0xdb, 0xdc, 0xd0, 0x94, 0x33,
	0x25, 0xbe, 0x8f, 0x0d, 0x21, 0x6a, 0xf3, 0xa3, 0x8d, 0x56, 0x19, 0xcb, 0x59, 0x62, 0x57, 0x1d,
	0x3c, 0x23, 0x77, 0xe7, 0xd2, 0x68, 0x5e, 0x6b, 0xa6, 0x45, 0xdf, 0x77, 0xbb, 0x06, 0x18, 0xa2,
	0x31, 0x9a, 0xf4, 0x66, 0x87, 0x64, 0x93, 0x36, 0x99, 0x37, 0xac, 0xbf, 0xb5, 0xfc, 0xd8, 0x77,
	0x02, 0xdb, 0xec, 0x9f, 0xba, 0x9d, 0x35, 0xa4, 0x86, 0xff, 0xc6, 0xff, 0x27, 0xbd, 0xd9, 0x80,
	0x18, 0x1f, 0xd2, 0xfa, 0x90, 0x8b, 0xb4, 0xf4, 0xb7, 0xdf, 0x5e, 0xa7, 0x9d, 0x39, 0x40, 0x7c,
	0x15, 0x18, 0xda, 0x0f, 0x96, 0x15, 0x46, 0xab, 0x0a, 0xa3, 0xcf, 0x0a, 0xa3, 0x97, 0x1a, 0x3b,
	0xab, 0x1a, 0x3b, 0xef, 0x35, 0x76, 0x6e, 0xce, 0x65, 0xa4, 0x1f, 0x0a, 0x4e, 0x42, 0x48, 0xa8,
	0x3d, 0x67, 0x1a, 0x33, 0xae, 0xda, 0x81, 0x2e, 0xbc, 0x33, 0xfa, 0xf4, 0x5b, 0x57, 0x97, 0x99,
	0x50, 0xbc, 0xdb, 0xec, 0x3c, 0xf9, 0x0a, 0x00, 0x00, 0xff, 0xff, 0x59, 0x60, 0xd0, 0x48, 0xe9,
	0x01, 0x00, 0x00,
}

func (m *GenesisState) Marshal() (dAtA []byte, err error) {
	size := m.Size()
	dAtA = make([]byte, size)
	n, err := m.MarshalToSizedBuffer(dAtA[:size])
	if err != nil {
		return nil, err
	}
	return dAtA[:n], nil
}

func (m *GenesisState) MarshalTo(dAtA []byte) (int, error) {
	size := m.Size()
	return m.MarshalToSizedBuffer(dAtA[:size])
}

func (m *GenesisState) MarshalToSizedBuffer(dAtA []byte) (int, error) {
	i := len(dAtA)
	_ = i
	var l int
	_ = l
	if len(m.Pools) > 0 {
		for iNdEx := len(m.Pools) - 1; iNdEx >= 0; iNdEx-- {
			{
				size, err := m.Pools[iNdEx].MarshalToSizedBuffer(dAtA[:i])
				if err != nil {
					return 0, err
				}
				i -= size
				i = encodeVarintGenesis(dAtA, i, uint64(size))
			}
			i--
			dAtA[i] = 0x12
		}
	}
	{
		size, err := m.Params.MarshalToSizedBuffer(dAtA[:i])
		if err != nil {
			return 0, err
		}
		i -= size
		i = encodeVarintGenesis(dAtA, i, uint64(size))
	}
	i--
	dAtA[i] = 0xa
	return len(dAtA) - i, nil
}

func encodeVarintGenesis(dAtA []byte, offset int, v uint64) int {
	offset -= sovGenesis(v)
	base := offset
	for v >= 1<<7 {
		dAtA[offset] = uint8(v&0x7f | 0x80)
		v >>= 7
		offset++
	}
	dAtA[offset] = uint8(v)
	return base
}
func (m *GenesisState) Size() (n int) {
	if m == nil {
		return 0
	}
	var l int
	_ = l
	l = m.Params.Size()
	n += 1 + l + sovGenesis(uint64(l))
	if len(m.Pools) > 0 {
		for _, e := range m.Pools {
			l = e.Size()
			n += 1 + l + sovGenesis(uint64(l))
		}
	}
	return n
}

func sovGenesis(x uint64) (n int) {
	return (math_bits.Len64(x|1) + 6) / 7
}
func sozGenesis(x uint64) (n int) {
	return sovGenesis(uint64((x << 1) ^ uint64((int64(x) >> 63))))
}
func (m *GenesisState) Unmarshal(dAtA []byte) error {
	l := len(dAtA)
	iNdEx := 0
	for iNdEx < l {
		preIndex := iNdEx
		var wire uint64
		for shift := uint(0); ; shift += 7 {
			if shift >= 64 {
				return ErrIntOverflowGenesis
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
			return fmt.Errorf("proto: GenesisState: wiretype end group for non-group")
		}
		if fieldNum <= 0 {
			return fmt.Errorf("proto: GenesisState: illegal tag %d (wire type %d)", fieldNum, wire)
		}
		switch fieldNum {
		case 1:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field Params", wireType)
			}
			var msglen int
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowGenesis
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
				return ErrInvalidLengthGenesis
			}
			postIndex := iNdEx + msglen
			if postIndex < 0 {
				return ErrInvalidLengthGenesis
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			if err := m.Params.Unmarshal(dAtA[iNdEx:postIndex]); err != nil {
				return err
			}
			iNdEx = postIndex
		case 2:
			if wireType != 2 {
				return fmt.Errorf("proto: wrong wireType = %d for field Pools", wireType)
			}
			var msglen int
			for shift := uint(0); ; shift += 7 {
				if shift >= 64 {
					return ErrIntOverflowGenesis
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
				return ErrInvalidLengthGenesis
			}
			postIndex := iNdEx + msglen
			if postIndex < 0 {
				return ErrInvalidLengthGenesis
			}
			if postIndex > l {
				return io.ErrUnexpectedEOF
			}
			m.Pools = append(m.Pools, &types.Any{})
			if err := m.Pools[len(m.Pools)-1].Unmarshal(dAtA[iNdEx:postIndex]); err != nil {
				return err
			}
			iNdEx = postIndex
		default:
			iNdEx = preIndex
			skippy, err := skipGenesis(dAtA[iNdEx:])
			if err != nil {
				return err
			}
			if (skippy < 0) || (iNdEx+skippy) < 0 {
				return ErrInvalidLengthGenesis
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
func skipGenesis(dAtA []byte) (n int, err error) {
	l := len(dAtA)
	iNdEx := 0
	depth := 0
	for iNdEx < l {
		var wire uint64
		for shift := uint(0); ; shift += 7 {
			if shift >= 64 {
				return 0, ErrIntOverflowGenesis
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
					return 0, ErrIntOverflowGenesis
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
					return 0, ErrIntOverflowGenesis
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
				return 0, ErrInvalidLengthGenesis
			}
			iNdEx += length
		case 3:
			depth++
		case 4:
			if depth == 0 {
				return 0, ErrUnexpectedEndOfGroupGenesis
			}
			depth--
		case 5:
			iNdEx += 4
		default:
			return 0, fmt.Errorf("proto: illegal wireType %d", wireType)
		}
		if iNdEx < 0 {
			return 0, ErrInvalidLengthGenesis
		}
		if depth == 0 {
			return iNdEx, nil
		}
	}
	return 0, io.ErrUnexpectedEOF
}

var (
	ErrInvalidLengthGenesis        = fmt.Errorf("proto: negative length found during unmarshaling")
	ErrIntOverflowGenesis          = fmt.Errorf("proto: integer overflow")
	ErrUnexpectedEndOfGroupGenesis = fmt.Errorf("proto: unexpected end of group")
)
