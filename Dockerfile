FROM    pbaldini/webots2021b-nnsc:2025
WORKDIR /home
USER    root

ENV     DEBIAN_FRONTEND=noninteractive
ENV     DISPLAY=:99
ENV     LD_LIBRARY_PATH=/usr/local/lib:/home/webots/bin
ENV     LIBGL_ALWAYS_SOFTWARE=true
ENV     OMP_NUM_THREADS=1
ENV     PYTHONPATH=/home/webots/lib/controller/python39:/home/controllers

RUN     pacman -S --noconfirm \
            python \
            xorg-server-xvfb \
            glu \
            nss \
            libxcomposite \
            libxdamage \
            libxcursor \
            libxtst \
            libxkbcommon \
            alsa-lib \
            libinput \
            shared-mime-info \
            libjpeg-turbo \
            fontconfig \
            qt5-base

ADD     configurations /home/configurations
ADD     controllers /home/controllers
ADD     machines /home/machines
ADD     worlds /home/worlds
ADD     requirements.txt /home
ADD     --chmod=0755 docker_entrypoint.sh /home

RUN     python -m venv .venv \
            && source .venv/bin/activate \
            && pip install -r requirements.txt
RUN     pacman -Ss chrome

RUN     chmod 777 -R /home
RUN     useradd -ms /bin/bash pbaldini
USER    pbaldini

CMD     [ "/home/docker_entrypoint.sh" ]
