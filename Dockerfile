FROM ubuntu:14.04
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y openssh-server firefox vim ttf-ubuntu-font-family
RUN apt-get install -y git build-essential libgnome-keyring-dev gconf2 libnss3
RUN apt-get install -y libpq-dev
#RUN apt-get install -y xvfb x11vnc
RUN mkdir /root/.vnc
#RUN x11vnc -storepasswd test01 /root/.vnc/passwd
#RUN Xvfb :1 -extension GLX -screen 0 1024x780x24 &
#RUN x11vnc -usepw -forever -display :1 &

RUN wget https://github.com/atom/atom/releases/download/v0.141.0/atom-amd64.deb
RUN dpkg -i atom-amd64.deb
RUN mkdir /var/run/sshd

RUN locale-gen bs_BA.UTF-8
RUN echo "LANG=bs_BA.UTF-8"  >  /etc/default/locale
RUN echo "LC_MESSAGES=POSIX" >> /etc/default/locale

RUN useradd -ms /bin/bash bringout
RUN echo "bringout:test01" | chpasswd
RUN echo "root:toor" | chpasswd

RUN mkdir -p /opt/knowhowERP
RUN chown bringout.bringout /opt/knowhowERP

RUN git clone https://github.com/hernad/harbour_core.git /home/bringout/harbour_core
RUN git clone https://github.com/knowhow/F18_knowhow.git /home/bringout/F18_knowhow
RUN chown -R bringout:bringout /home/bringout

USER bringout
ENV HOME /home/bringout
WORKDIR /home/bringout
#RUN wget http://ftp.fau.de/qtproject/archive/qt/5.3/5.3.2/qt-opensource-linux-x64-5.3.2.run
#RUN chmod +x qt-opensource-linux-x64-5.3.2.run

RUN git clone https://github.com/hernad/docker-ubuntu-qt.git /home/bringout/Qt
RUN git clone https://github.com/hernad/docker-ubuntu-dot-atom.git /home/bringout/.atom

RUN cd /home/bringout/harbour_core && git checkout F18_master
RUN cd /home/bringout/F18_knowhow && . scripts/ubuntu_set_envars.sh && cd /home/bringout/harbour_core && make install

RUN echo "#!/bin/bash" > /home/bringout/.bash_profile
RUN echo "cd ~/F18_knowhow" >> /home/bringout/.bash_profile
RUN echo ". scripts/ubuntu_set_envars.sh" >> /home/bringout/.bash_profile
RUN chmod +x /home/bringout/.bash_profile

#RUN DISPLAY=:1 ./qt-opensource-linux-x64-5.3.2.run

USER root
ENV HOME /root
EXPOSE 22

CMD [ "/usr/sbin/sshd", "-D" ]
