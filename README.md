# Voting Application
![Architecture diagram](./images/vote-app.png)
* A front-end web app in [Python](./voting-app/vote/) that lets you vote between two options
* A [Redis](https://hub.docker.com/_/redis/) which collects new votes
* A [.NET](./voting-app/worker/) worker which consumes votes and stores them in the database
* A [Postgres](https://hub.docker.com/_/postgres/) database backed by a Docker volume
* A [Node.js](./voting-app/result/) web app that shows the results of the voting in real time

> ## Notes
> The voting application only accepts one vote per client browser.  
It does not register additional votes if a vote has already been submitted by a client.  
This is used only as show case for Skaffold remote development.

## Run the Vote Application via Skaffold

Change into `voting-app` directory and start your development environment with:
```bash
export IMAGE_SUFFIX=$(git rev-parse --short HEAD)
echo "IMAGE_TAG=$IMAGE_SUFFIX" > skaffold.env
skaffold dev
```
