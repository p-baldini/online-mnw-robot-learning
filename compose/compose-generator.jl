using Base.Iterators

const IMAGE_NAME="quay.io/p-baldini/2025-etm:3.1.0"
const TASK="tm"
const STRATEGY="A"
const ARENA="collision_avoidance-round.wbt"
const BASE_DIR="/home/persistent/2025-etm-3.1.0"
const EXPERIMENTS_PER_CONTAINER=5
const REPLICAS=100

file = open("compose-$TASK-$STRATEGY.yaml", "w")

header =
"""
version: '3.9'

services:
"""
write(file, header)

SEED_RANGES = 1:EXPERIMENTS_PER_CONTAINER:REPLICAS

template(SEED) = 
"""
  $TASK-$STRATEGY-$SEED:
    image: $IMAGE_NAME
    environment:
      - WORK_DIR=$BASE_DIR/$TASK/$STRATEGY/
      - TASK=$TASK
      - STRATEGY=$STRATEGY
      - START_SEED=$SEED
      - REPLICAS=$EXPERIMENTS_PER_CONTAINER
      - ARENA=$ARENA
    volumes:
      - "data:/home/persistent"
      - type: tmpfs
        target: /dev/shm
        tmpfs:
           size: 131072
    entrypoint: "/home/docker_entrypoint.sh"
"""

for seed in SEED_RANGES
    write(file, template(seed))
end

volumes =
"""
volumes:
  data:
    name: paolo.baldini-volume
"""
write(file, volumes)

close(file)
