package main

import (
	"fmt"

	// Simulate a dependency on go-delve which is also used in thirdparty subrepo
	dlvversion "github.com/go-delve/delve/pkg/version"

	"golang.org/x/example/hello/reverse"
)

func main() {
	const s = "foo"

	fmt.Printf("delve is %#v\n", dlvversion.DelveVersion)
	fmt.Printf("reverse of '%s' is '%s'\n", s, reverse.String(s))
}
