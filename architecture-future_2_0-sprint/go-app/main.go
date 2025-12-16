package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"
	"os"

	_ "github.com/lib/pq"
)

// Database connection
var db *sql.DB

func main() {
	// Initialize database connection
	initDB()
	defer db.Close()

	// Set up HTTP routes
	http.HandleFunc("/health", handleHealth)

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	log.Printf("Starting service on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}

func initDB() {
	connStr := os.Getenv("DB_CONNECTION_STRING")
	if connStr == "" {
		connStr = "postgres://postgres:postgres@localhost/postgres?sslmode=disable"
	}

	var err error
	db, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}

	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Successfully connected to database")
}

func handleHealth(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]bool{"status": true})
}
