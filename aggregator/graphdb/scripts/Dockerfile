FROM khaller/graphdb-free:1.3.5-graphdb9.11.2
#
RUN apt-get update && \
apt-get install curl unzip -y

RUN apt-get install rsync -y

ADD https://www.hydroshare.org/resource/bddbac6878a743ce847ddf0714f21f6d/data/contents/data.zip /opt/data.zip
RUN cd /opt && unzip data.zip 
RUN rsync -r --remove-source-files /opt/data /opt/graphdb

ADD https://www.hydroshare.org/resource/bddbac6878a743ce847ddf0714f21f6d/data/contents/work.zip /opt/work.zip
RUN cd /opt && unzip work.zip 
RUN rsync -r --remove-source-files /opt/work /opt/graphdb
