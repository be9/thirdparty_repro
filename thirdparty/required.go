// Package thirdparty is a faux Go package to prevent go commands from
// removing these modules from go.mod.
package thirdparty

import (
	_ "github.com/daixiang0/gci"
	_ "github.com/go-delve/delve/cmd/dlv"
	_ "github.com/golang/protobuf/protoc-gen-go"
	_ "github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway"
)
