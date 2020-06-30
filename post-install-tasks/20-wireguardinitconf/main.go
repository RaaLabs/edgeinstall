// To compile:
// env GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" && upx --brute wireguardinitconf

package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net"
	"os"
	"os/exec"
	"strings"
	"text/template"
)

// wireguard will be used to hold all the values to be written to the configuration file
type config struct {
	LocalPrivateKey string `json:"PrivateKey"`
	LocalPublicKey  string
	LocalAddress    string   `json:"Address"`
	PeerPubKey      string   `json:"PublicKey"`
	AllowedIPs      []string `json:"AllowedIPs"`
	EndPointAndPort string   `json:"Endpoint"`
}

func main() {

	// Parse the flags
	localAddress := flag.String("localAddress", "", "the local ip of the wireguard client, e.g. 10.10.10.10/32")
	endPointAndPort := flag.String("endPointAndPort", "", "the endpoint and port to connect to, e.g. onewire.somesite.com:5560")
	configDir := flag.String("configDir", "./wireguard/", "the location where the config will be written to, and you probably want to set this to '/etc/wireguard/'")
	flag.Parse()

	if *localAddress == "" {
		fmt.Printf("Info: you need to specify a -localAddress\n")
		os.Exit(1)
	}

	cfg, err := getConfig()
	if err != nil {
		log.Printf("%v\n", err)
		os.Exit(1)
	}

	// Check if the values of the ip address are valid
	if err := checkIP(*localAddress); err != nil {
		log.Printf("error: checkIP failed: %v\n", err)
		os.Exit(1)
	}

	// ******* Fill missing values from config, and
	// ******* generate output

	if *endPointAndPort != "" {
		cfg.EndPointAndPort = *endPointAndPort
	}

	// Generate the keys,
	cfg.LocalPrivateKey, cfg.LocalPublicKey, err = generateKeys(*configDir)
	if err != nil {
		log.Printf("%v\n", err)
		os.Exit(1)
	}

	cfg.LocalAddress = *localAddress

	// Create config files and output to the screen
	createOutput(*configDir, cfg)
}

// createOutput will write all config files and the information
// to the user on the screen
func createOutput(configDir string, cfg config) {
	// Get the template
	tpl, err := template.ParseFiles("./wireguard-wg0.conf.tmpl")
	if err != nil {
		log.Printf("error: template.ParseFiles: %v\n", err)
		return
	}

	fhConf, err := os.Create(configDir + "wg0.conf")
	if err != nil {
		log.Printf("error: os.Create: %v\n", err)
		return
	}
	defer fhConf.Close()

	// Execute filling of the template, and put it all into the wg0.conf file.
	if err := tpl.Execute(fhConf, cfg); err != nil {
		log.Printf("error: tpl.Execute failed: %v\n", err)
		return
	}

	fmt.Println("-----------------------------------------------------------------------------")
	fmt.Printf("\n*** The command to paste in to the wireguard server\n")
	fmt.Printf("wg set wg0 peer %v allowed-ips %v", cfg.LocalPublicKey, cfg.LocalAddress)
	fmt.Println("\n-----------------------------------------------------------------------------")
}

func getConfig() (config, error) {
	// Open and unmarshal the values of the json config file
	fhJSON, err := os.Open("./wireguard-wg0.conf.json")
	if err != nil {
		log.Printf("error: os.Open failed: %v\n", err)
		return config{}, err
	}
	defer fhJSON.Close()

	var wg config
	d := json.NewDecoder(fhJSON)
	d.Decode(&wg)

	return wg, nil
}

// generateKeys will run the wg commands on the os to generate
// the private and public keys. The content of the key files will
// be read back, stripped of any newlines, and returned.
func generateKeys(folder string) (privateKey string, publicKey string, err error) {

	// Generate the key and config folder if it do not exist
	if _, err := os.Stat(folder); os.IsNotExist(err) {
		os.Mkdir(folder, 0700)
	}

	_, err = exec.Command("bash", "-c", "wg genkey | tee "+folder+"privatekey | wg pubkey > "+folder+"publickey").Output()
	if err != nil {
		return "", "", fmt.Errorf("error: exec.Command failed: %v", err)
	}

	// Read public key

	fhPub, err := os.Open(folder + "publickey")
	if err != nil {
		return "", "", fmt.Errorf("error: os.Open failed: %v", err)
	}
	defer fhPub.Close()

	b, err := ioutil.ReadAll(fhPub)
	if err != nil {
		return "", "", fmt.Errorf("error: ioutil.ReadAll failed: %v", err)
	}
	pubKey := string(b)
	pubKey = strings.TrimSuffix(pubKey, "\n")

	// Read private key

	fhPri, err := os.Open(folder + "privatekey")
	if err != nil {
		return "", "", fmt.Errorf("error: os.Open failed: %v", err)
	}
	defer fhPri.Close()

	b, err = ioutil.ReadAll(fhPri)
	if err != nil {
		return "", "", fmt.Errorf("error: ioutil.ReadAll failed: %v", err)
	}
	privKey := string(b)
	privKey = strings.TrimSuffix(privKey, "\n")

	return privKey, pubKey, nil
}

// checkIP will do some basic checking and try to figure
// out if the both the ip address and mask are valid.
func checkIP(ip string) error {
	// Parse the cidr, and do the initial checking if it seems valid.
	localIP, ipNet, err := net.ParseCIDR(ip)
	if err != nil {
		return fmt.Errorf("error: net.ParseCIDR failed: %v", err)
	}

	// Check if the netmask i /32
	if ipNet.Mask.String() != "ffffffff" {
		return fmt.Errorf("error: you should use /32 mask for host ip, e.g. 10.20.30.40/32")
	}

	// Check if the address is valid
	valid := net.ParseIP(localIP.String())
	if valid == nil {
		return fmt.Errorf("error: net.ParseIP not valid IP: %v", err)
	}

	return nil
}
