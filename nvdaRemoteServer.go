package main

import (
	. "github.com/tech10/nvdaRemoteServer/server"
	"os"
	"strconv"
	"strings"
	"sync"
)

var Version string = "development"

func main() {
	err := Configure()
	if err != nil {
		return
	}
	num := Start()
	if num == 0 {
		return
	}
	Version = strings.TrimPrefix(Version, "v")
	Log(LOG_INFO, "Server started. Running under PID "+strconv.Itoa(os.Getpid())+". Server version "+Version)
	wait()
	Log(LOG_INFO, "Server shutdown complete.")
}

func wait() {
	var wg sync.WaitGroup
	if S4 != nil {
		wg.Add(1)
		go func() {
			S4.Wait()
			wg.Done()
		}()
	}
	if S6 != nil {
		wg.Add(1)
		go func() {
			S6.Wait()
			wg.Done()
		}()
	}
	if SAll != nil {
		wg.Add(1)
		go func() {
			SAll.Wait()
			wg.Done()
		}()
	}
	wg.Wait()
}
