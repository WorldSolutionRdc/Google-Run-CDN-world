FROM alpine

# Installation des dépendances
RUN apk update && apk add \
    nodejs \
    gcc \
    g++ \
    cmake \
    make \
    tmux \
    dropbear \
    bash \
    linux-headers \
    curl

WORKDIR /workdir

# Copier les fichiers
COPY badvpn-src/ ./badvpn-src
COPY proxy3.js ./
COPY run.sh ./

# Compiler badvpn
WORKDIR /workdir/badvpn-src
RUN mkdir -p build
WORKDIR /workdir/badvpn-src/build
RUN cmake .. -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_TUN2SOCKS=1 -DBUILD_UDPGW=1 -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5
RUN make -j2 install

# Nettoyer et configurer
WORKDIR /workdir
RUN rm -rf badvpn-src
RUN echo -e "/bin/false\n/usr/sbin/nologin\n" >> /etc/shells
RUN adduser -D -h /home/test test -s /bin/false 2>/dev/null || true
RUN echo "test:qweasdzxc" | chpasswd
RUN chmod +x /workdir/run.sh

EXPOSE 8080

CMD ./run.sh
