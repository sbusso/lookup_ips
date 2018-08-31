package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
)

func showIPHandler(w http.ResponseWriter, r *http.Request) {
	ifs, err := net.Interfaces()

	if err != nil {
		log.Fatal(err)
	}

	for _, ief := range ifs {
		fmt.Fprintln(w, ief.Name)
		addrs, err := ief.Addrs()

		if err != nil {
			log.Fatal(err)
		}

		for _, addr := range addrs {
			// if addr.isLookback
			fmt.Fprintln(w, "- "+addr.String())
		}
	}

}

func main() {
	http.HandleFunc("/", showIPHandler)      // set router
	err := http.ListenAndServe(":9000", nil) // set listen port
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
