- [Docker Compose Cheat sheet](#docker-compose-cheat-sheet)
  - [Basic file](#basic-file)
  - [Commands](#commands)

# Docker Compose Cheat sheet

## Basic file

```yaml
networks:
  counter-net:

volumes:
  counter-vol:
  
services:
  web-fe:
    build: .
    command: python app.py
    ports:
      - target: 8080
        published: 5001
    networks:
      - counter-net
    volumes:
      - type: volume
        source: counter-vol
        target: /app
  redis:
    image: "redis:alpine"
    networks:
      counter-net:

```

Define a network called `counter-net` and a volume called `counter-vol`
```yaml
networks:
  counter-net:

volumes:
  counter-vol:
```

Two services under
```
services:
```
we call this a multi container app

## Commands

Build all the networks and volumes and bring it up. Has to run this where the compose.yaml is
```powershell
docker compose up -- detach
```

- `detach` - run it in the background and dont tie up the terminal

To bring it down:
```powershell
docker compose down --volumes
```

- `volumes` clean up volumes as well because normally they stay around in case you have important data on it