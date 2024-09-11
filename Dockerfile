FROM kasmweb/core-ubuntu-focal:1.15.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# Install Chromium
COPY ./src/ubuntu/install/chromium $INST_SCRIPTS/chromium/
RUN bash $INST_SCRIPTS/chromium/install_chromium.sh && rm -rf $INST_SCRIPTS/chromium/

RUN apt-get update && apt-get install flatpak
RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
RUN flatpak install flathub com.plexamp.Plexamp

# Install VLC
RUN apt-get update && apt-get install -y vlc

# Install Picard
RUN add-apt-repository ppa:musicbrainz-developers/stable && apt-get update && apt-get install -y picard

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
