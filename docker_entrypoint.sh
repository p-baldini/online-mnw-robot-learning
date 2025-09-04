#!/bin/bash

cp configurations/$TASK.json config.json
cp machines/tsetlin-$STRATEGY.json tsetlin.json

mkdir -p $WORK_DIR

sed -i "s|../../aa/|$WORK_DIR|" config.json && cat config.json
sed -i "s|../../ca/|$WORK_DIR|" config.json && cat config.json
sed -i "s|../../fg/|$WORK_DIR|" config.json && cat config.json
sed -i "s|../../tm/|$WORK_DIR|" config.json && cat config.json
sed -i "s/\"starting_seed\":        1/\"starting_seed\":        $START_SEED/" config.json
sed -i "s/\"replicas_count\":       100/\"replicas_count\":       $END_SEED/" config.json

./start_headless.sh main.py $ARENA
