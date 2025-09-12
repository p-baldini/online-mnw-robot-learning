from functools import reduce
from inout.loader import configs
from operator import sub
from simulation.replica import range2range
from webots.robot import get_actuators, get_sensors, robot

MAX_OUTPUT = configs["actuators"]["max_output"]
MIN_OUTPUT = configs["actuators"]["min_output"]
PRIZE = configs["task"]["max_step_prize"]
PENALTY = configs["task"]["max_step_penalty"]


def evaluate():
    # get the perceived ground color
    value = next(iter(get_sensors(robot).values())).getValue()

    # if robot hovers an illegal area (white color), penalize it
    performance = PRIZE if value <= 825 else PENALTY

    # get motors velocities and make them in range 0-1
    speeds = [motor.getVelocity() for _, motor in get_actuators(robot).items()]
    speeds = [range2range(value, (0, MAX_OUTPUT)) for value in speeds]

    # calculate average speed and direction of the robot
    average_speed = sum(speeds) / 2.0
    directions = 1 - abs(reduce(sub, speeds))

    # prefer straight and fast movements
    return performance * directions * average_speed


__all__ = "evaluate",
