package main

import (
	"fmt"

	"golang.org/x/example/hello/reverse"
)

func main() {
	const s = "foo"

	fmt.Printf("reverse of '%s' is '%s'\n", s, reverse.String(s))
}
