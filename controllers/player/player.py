from functools import reduce
from inout.loader import configs
from inout.logger import logger
from inout.saver import save, exists
from itertools import filterfalse
from os import EX_OK
from simulation.epoch import run_epoch
from simulation.replica import Replica, random_replica, terminate_replica
from webots.supervisor import supervisor

STARTING_SEED = configs["task"]["starting_seed"]
REPLICAS_COUNT = configs["task"]["replicas_count"]
EPOCHS_COUNT = configs["task"]["epochs_count"]

# skip already completed replicas (useful when the experiment run on docker swarm)
replicas = filterfalse(exists, range(STARTING_SEED, STARTING_SEED + REPLICAS_COUNT))

# generate new replicas, each with its own control (they have different seeds)
replicas = map(random_replica, replicas)


def describe(replica: Replica) -> Replica:
    logger.info(replica.network)
    logger.info(f"new phase: {replica.tsetlin.state.type} (idx: {replica.tsetlin.state_idx})")
    return replica


# describe all the replica controllers
replicas = map(describe, replicas)

# run each replica for the specified number of epochs, adapting it each time
replicas = map(lambda x: reduce(run_epoch, range(EPOCHS_COUNT), x), replicas)

# commit the save of each replica results
replicas = map(save, enumerate(replicas, start=STARTING_SEED))

# terminate the replica of the experiment (a.k.a., reset)
list(map(terminate_replica, replicas))

# end of the simulation
logger.info("Simulation complete")

# exit webots
supervisor.simulationQuit(EX_OK)
