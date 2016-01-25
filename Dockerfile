# Useful Dockerfile to test new features in a fresh environment.
# Expect to have a Debian Jessie image with a recent "apt-get update", called jessie-up.
# Build image using "docker build ."
# Launch container using a command like this :
#     docker run -i -t -v $HOME/git/kvm-simple-init/:$HOME/git/kvm-simple-init/ $IMAGE_ID /bin/bash
FROM debian:jessie-up
RUN apt-get install --force-yes -y netcat
CMD mkdir -p /etc/kvm-simple-init/
ADD config.example /etc/kvm-simple-init/test1
