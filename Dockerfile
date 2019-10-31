FROM ubuntu:18.04

# Prevent tzdata from hanging during apt-get
ENV TZ=America/Los_Angeles
RUN \
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone

# Postgres Install and Configuration
RUN apt-get -q update && apt-get install -y -q wget sudo gnupg lsb-release
# USER docker 

RUN wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Updating deb list with postgresql-11 and install
RUN RELEASE=$(lsb_release -cs) \
	&& echo "deb http://apt.postgresql.org/pub/repos/apt/ ${RELEASE}-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install -y -q postgresql-11 

# Starting postgresql-11 as Postgres User
USER postgres
# RUN /etc/init.d/postgresql start && echo "Postgres Server Started"

# Copying Orpheus Files Over/Configuring happens outside
COPY . /orpheus

# Used to start postgres on startup; do not override
CMD /etc/init.d/postgresql start && /bin/bash 
