package main

import (
	"fmt"
	"os"
	"os/exec"
)

func ClearAnsiblePaths() {
	fmt.Printf("waat")
	ANSIBLE_GENERATED_PATH := os.Getenv("ANSIBLE_GENERATED")
	ansible_generated_path := fmt.Sprintf("%v*", ANSIBLE_GENERATED_PATH)

	cmd := exec.Command("/bin/bash", "rm", "-f", ansible_generated_path)
	cmd.Run()
}

func Destroy() error {
	SCRIPTS_PATH := os.Getenv("SCRIPTS_PATH")
	script := fmt.Sprintf("%vdestroy.sh", SCRIPTS_PATH)

	fmt.Printf("Executing script from path: %v \n", script)

	cmd := exec.Command("bash", "-c", script)

	if _, err := cmd.Output(); err != nil {
		fmt.Println("Error encountered!")
		return err
	}
	fmt.Println("Script executed")
	return nil
}
