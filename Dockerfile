FROM    pbaldini/webots2021b-nnsc
WORKDIR /home
ENV     LD_LIBRARY_PATH="/usr/local/lib"

RUN     add-apt-repository ppa:deadsnakes/ppa \
            && apt update \
            && apt install -y python3.13 python3.13-venv \
            && apt remove -y python3.8

COPY    configurations /home/configurations
COPY    controllers /home/controllers
COPY    machines /home/machines
COPY    worlds /home/worlds
COPY    main.py /home
COPY    requirements.txt /home
COPY    --chmod=0755 start_headless.sh /home
COPY    --chmod=0755 docker_entrypoint.sh /home

CMD     [ "/home/docker_entrypoint.sh" ]
