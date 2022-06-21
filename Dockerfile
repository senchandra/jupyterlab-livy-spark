FROM ubuntu:20.04

RUN apt-get update
RUN apt-get install -y --no-install-recommends gnupg net-tools openssh-server openjdk-8-jdk nano curl \
    wget libmysqlclient-dev libssl-dev libkrb5-dev unzip gcc xz-utils

RUN echo "deb http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com/ --recv-keys BA6932366A755776 && \
    apt-get update
RUN apt-get install -y --no-install-recommends python3.7 python3.7-distutils python3.7-dev
RUN ln -s /usr/bin/python3.7 /usr/bin/python && \
    ln -s /usr/bin/python3.7 /usr/bin/python3
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

ENV SPARK_HOME /opt/spark
ENV PATH $PATH:$SPARK_HOME/bin
ENV PYSPARK_PYTHON=python3
RUN wget -O - "https://archive.apache.org/dist/spark/spark-2.4.8/spark-2.4.8-bin-hadoop2.7.tgz" \
  | gunzip \
  | tar x -C /opt/ \
  && mv /opt/spark-2.4.8-bin-hadoop2.7 /opt/spark

ENV LIVY_HOME /opt/livy
ENV PATH $PATH:$LIVY_HOME/bin
RUN wget "https://archive.apache.org/dist/incubator/livy/0.7.1-incubating/apache-livy-0.7.1-incubating-bin.zip" && \
    unzip apache-livy-0.7.1-incubating-bin.zip && \
    rm -rf apache-livy-0.7.1-incubating-bin.zip && \
    mv apache-livy-0.7.1-incubating-bin /opt/livy
RUN touch /opt/livy/conf/livy.conf && \
    echo "livy.spark.master=spark://127.0.1.1:7077" > /opt/livy/conf/livy.conf

RUN wget https://nodejs.org/dist/v16.15.1/node-v16.15.1-linux-x64.tar.xz && \
    tar -xf node-v16.15.1-linux-x64.tar.xz && \
    rm -rf node-v16.15.1-linux-x64.tar.xz && \
    mv node-v16.15.1-linux-x64 /opt/node
ENV PATH $PATH:/opt/node/bin

RUN pip3 install sparkmagic jupyterlab
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension && \
    jupyter labextension install "@jupyter-widgets/jupyterlab-manager"
RUN jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/sparkkernel && \
    jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/pysparkkernel && \
    jupyter-kernelspec install --user $(pip show sparkmagic | grep Location | cut -d" " -f2)/sparkmagic/kernels/sparkrkernel 
RUN mkdir -p /root/.sparkmagic
COPY config.json /root/.sparkmagic/config.json
RUN jupyter serverextension enable --py sparkmagic

RUN pip3 install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
