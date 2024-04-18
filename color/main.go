package main

import (
	"fmt"
)

func main() {
	fmt.Println(fmt.Sprintf("[%s]This is an info message", "\033[34mINFO\033[0m"))
	fmt.Println(fmt.Sprintf("[%s]This is a warning message", "\033[33mWARN\033[0m"))
	fmt.Println(fmt.Sprintf("[%s]This is an error message", "\033[31mERROR\033[0m"))
}
