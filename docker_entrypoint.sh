#!/bin/bash

cp configurations/$TASK.json config.json
cp machines/tsetlin-$STRATEGY.json tsetlin.json

mkdir -p $WORK_DIR && chmod 777 -R $WORK_DIR

sed -i "s|../../aa/|$WORK_DIR|" config.json
sed -i "s|../../ca/|$WORK_DIR|" config.json
sed -i "s|../../fg/|$WORK_DIR|" config.json
sed -i "s|../../tm/|$WORK_DIR|" config.json
sed -i "s/\"starting_seed\":        1/\"starting_seed\":        $START_SEED/" config.json
sed -i "s/\"replicas_count\":       100/\"replicas_count\":       $END_SEED/" config.json

Xvfb :99 -screen 0 1024x768x16 2>&1 | tee log &
source .venv/bin/activate
ulimit -s 65535
webots --mode=fast --no-rendering --minimize --batch --stdout --stderr --log-performance=stdout worlds/$ARENA 2>&1 | tee -a log
