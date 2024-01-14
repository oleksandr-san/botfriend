/*
Copyright © 2023 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/spf13/cobra"
	tele "gopkg.in/telebot.v3"
)

var TELE_TOKEN = os.Getenv("TELE_TOKEN")

// botCmd represents the bot command
var botCmd = &cobra.Command{
	Use:     "bot",
	Aliases: []string{"start", "init"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		log.Printf("running bot version: %s, commit: %s\n", appVersion, appCommit)
		runBot()
	},
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	// Check the health of the server and return a status code accordingly
	if serverIsHealthy() {
		w.WriteHeader(http.StatusOK)
		fmt.Fprint(w, "Server is healthy")
	} else {
		w.WriteHeader(http.StatusInternalServerError)
		fmt.Fprint(w, "Server is not healthy")
	}
}

func serverIsHealthy() bool {
	// Check the health of the server and return true or false accordingly
	// For example, check if the server can connect to the database
	return true
}

func runBot() {
	http.HandleFunc("/", healthHandler)
	log.Println("Listening on port 80")
	go http.ListenAndServe(":80", nil)

	pref := tele.Settings{
		Token:  TELE_TOKEN,
		Poller: &tele.LongPoller{Timeout: 10 * time.Second},
	}

	bot, err := tele.NewBot(pref)
	if err != nil {
		log.Fatalf("Please check TELE_TOKEN env variable. %s", err)
		return
	}

	bot.Handle("/hello", func(c tele.Context) error {
		return c.Send("Hello!")
	})

	bot.Handle(tele.OnText, func(c tele.Context) error {
		payload := c.Message().Payload
		log.Printf("Received message with payload='%s' and text='%s'", payload, c.Text())

		switch payload {
		case "hello":
			err := c.Send(fmt.Sprintf("Hello %s, I'm bot %s", c.Sender().FirstName, appVersion))
			if err != nil {
				log.Print("Can't send message", err)
				return err
			}
		default:
			err := c.Send(fmt.Sprintf("I don't understand %s", payload))
			if err != nil {
				log.Print("Can't send message", err)
				return err
			}
		}
		return nil
	})

	bot.Start()
}

func init() {
	rootCmd.AddCommand(botCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// botCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// botCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
