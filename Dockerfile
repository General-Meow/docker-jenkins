# build: docker build -t generalmeow/jenkins:<TAG> .
# run: docker run -d --restart always --name jenkins -p 8080:8080 -p 5000:5000 -v /var/run/docker.sock:/var/run/docker.sock -v /home/jenkins_home:/home/.jenkins -e JENKINS_HOME='/home/.jenkins'  generalmeow/jenkins:<TAG>
# notes: the base image ubuntu supports many architectures including arm. to make it work, you just
# need to build the image on an arm based machine. It also needs to mount the docker socket from the host
FROM ubuntu:18.04
MAINTAINER Paul Hoang 2018-05-21
RUN ["apt", "update"]
RUN ["apt", "upgrade", "-y"]
RUN ["apt", "install", "wget", "git", "maven", "docker.io", "-y"]

# RUN ["useradd", "-ms", "/bin/bash", "paul"]
RUN ["usermod", "-aG", "docker", "root"]
WORKDIR /home
RUN ["wget", "http://mirrors.jenkins.io/war-stable/latest/jenkins.war", "-O", "/home/jenkins.war"]

ADD ["./files/jdk-8u181-linux-x64.tar.gz", "/home"]
ENV JAVA_HOME=/home/jdk1.8.0_181
ENV CLASSPATH=.
ENV PATH=${JAVA_HOME}/bin:${PATH}

RUN ["mkdir", "-p", "/home/.jenkins"]
VOLUME ["/home/.jenkins"]
EXPOSE 8080
EXPOSE 5000

ENTRYPOINT ["java", "-Xmx512m", "-Xms512m", "-jar", "/home/jenkins.war"]
