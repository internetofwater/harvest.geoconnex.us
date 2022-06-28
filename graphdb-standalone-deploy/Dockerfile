FROM khaller/graphdb-free:1.3.5-graphdb9.11.2

RUN apt-get update && \
apt-get install curl unzip -y

RUN rm /opt/graphdb/data -rf
ADD gdb/data.zip /opt/graphdb/data.zip
RUN cd /opt/graphdb && unzip data.zip 
