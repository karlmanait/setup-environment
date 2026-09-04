# Setup
1. Point a domain (or subdomain) of your own to the IP of the machine that will run the containers
1. Make sure the domain resolves correctly (e.g., an A record pointing to the right IP)

# Installation
1. Copy `.env.example` to `.env` and set your domain and data directory:
   `cp .env.example .env`
1. Edit the values in `.env` (domain and where to store persistent data)
1. Bring up the containers: `docker compose up -d`

# Access
1. Go to your domain using your web browser