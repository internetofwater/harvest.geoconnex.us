FROM khaller/graphdb-free:1.3.5-graphdb9.11.2

RUN apt-get update && \
apt-get install curl unzip -y

RUN rm /opt/graphdb/data -rf
ADD https://www.hydroshare.org/resource/bddbac6878a743ce847ddf0714f21f6d/data/contents/data.zip /opt/graphdb/data.zip
RUN cd /opt/graphdb && unzip data.zip 

RUN rm /opt/graphdb/work -rf
ADD https://www.hydroshare.org/resource/bddbac6878a743ce847ddf0714f21f6d/data/contents/work.zip /opt/graphdb/work.zip
RUN cd /opt/graphdb && unzip work.zip 
