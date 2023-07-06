package main

import (
	"flag"
	"fmt"
	"os"
	"strconv"
)

type Configuration struct {
	MasterNodes    int
	WorkerNodes    int
	MasterMemory   int
	WorkerMemory   int
	MasterCPU      int
	WorkerCPU      int
	NetworkAddress string
	Destroy        bool
}

func NewConfiguration(
	mn,
	wn,
	mm,
	wm,
	mcpu,
	wcpu int,
	netaddr string,
	dest bool) *Configuration {
	return &Configuration{
		MasterNodes:    mn,
		WorkerNodes:    wn,
		MasterMemory:   mm,
		WorkerMemory:   wm,
		MasterCPU:      mcpu,
		WorkerCPU:      wcpu,
		NetworkAddress: netaddr,
		Destroy:        dest,
	}
}

func Message(msg string, v any) {
	fmt.Printf("--------------------------------------------------\n")
	fmt.Println("MESSAGE")
	fmt.Println(msg)
	fmt.Printf("--------------------------------------------------\n")
	if v != nil {
		fmt.Printf("VALUES: %v\n\n", v)
	}

}

func ReadEnvs() (*Configuration, error) {

	masterNodes, err := strconv.Atoi(os.Getenv("MASTER_NODES"))
	if err != nil {
		return nil, fmt.Errorf("formatting error")
	}
	workerNodes, err := strconv.Atoi(os.Getenv("WORKER_NODES"))
	if err != nil {
		return nil, fmt.Errorf("formatting error")
	}
	masterMemory, err := strconv.Atoi(os.Getenv("MASTER_MEMORY"))
	if err != nil {
		return nil, fmt.Errorf("formatting error")
	}
	workerMemory, err := strconv.Atoi(os.Getenv("WORKER_MEMORY"))
	if err != nil {
		return nil, fmt.Errorf("formatting error")
	}
	masterCPU, err := strconv.Atoi(os.Getenv("MASTER_CPU_COUNT"))
	if err != nil {
		return nil, fmt.Errorf("formatting error")
	}
	workerCPU, err := strconv.Atoi(os.Getenv("WORKER_CPU_COUNT"))
	if err != nil {
		return nil, fmt.Errorf("formatting error")
	}
	networkAddr := os.Getenv("NETWORK_ADDRESSING")
	destroy := false

	return NewConfiguration(
		masterNodes,
		workerNodes,
		masterMemory,
		workerMemory,
		masterCPU,
		workerCPU,
		networkAddr,
		destroy,
	), nil
}
func ParseFlags(conf *Configuration) (*Configuration, error) {

	var help bool

	flag.IntVar(&conf.MasterNodes, "master-nodes", conf.MasterNodes, "Number of master nodes in the k8s cluster")
	flag.IntVar(&conf.WorkerNodes, "worker-nodes", conf.WorkerNodes, "Number of worker nodes in the k8s cluster")
	flag.IntVar(&conf.MasterMemory, "master-memory", conf.MasterMemory, "Amount of memory assigned to Master Nodes (in MB)")
	flag.IntVar(&conf.WorkerMemory, "worker-memory", conf.WorkerMemory, "Amount of memory assigned to Worker Nodes (in MB)")
	flag.IntVar(&conf.MasterCPU, "master-cpu", conf.MasterCPU, "Number of CPUs for Master Nodes")
	flag.IntVar(&conf.WorkerCPU, "worker-cpu", conf.WorkerCPU, "Number of CPUs for Worker Nodes")
	flag.StringVar(&conf.NetworkAddress, "network-address", conf.NetworkAddress, "IP Address for the subnet")
	flag.BoolVar(&conf.Destroy, "destroy", conf.Destroy, "Destroy the infrastructure")
	flag.BoolVar(&help, "help", false, "Display help info")
	flag.Parse()

	if help {
		fmt.Println("--------------------------------------------------------------------------------------------------")
		fmt.Println("\t\t\t\tK8s Provisioner tool")
		fmt.Printf("\tThis tool automates scripts used for automatic deployment of k8s cluster in VirtualBox\n")
		fmt.Println("--------------------------------------------------------------------------------------------------")
		fmt.Println("")
		fmt.Printf("Usage:\n")

		flag.PrintDefaults()
		os.Exit(0)
	}

	return conf, nil
}

func main() {
	conf, err := ReadEnvs()
	if err != nil {
		panic(err)
	}
	config, err := ParseFlags(conf)
	if err != nil {
		panic(err)
	}
	fmt.Println(config)
}
