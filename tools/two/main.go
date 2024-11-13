package main

import (
	"fmt"
	"time"

	"golang.org/x/exp/rand"
)

func main() {
	rand.Seed(uint64(time.Now().UnixNano()))

	fmt.Println("A random number for you:", rand.Int63())
}
