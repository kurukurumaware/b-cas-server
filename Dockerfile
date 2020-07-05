# SMART-CARD server 
# Build environment x86_64
FROM kurukurumaware/part-scard-start AS Scard-start

# Smart Card Server
FROM alpine:3.12 AS B-CAS-build

WORKDIR /tmp
RUN set -x 
RUN apk upgrade --update
RUN apk add --no-cache bash ccid socat

# pcsc-lite-libs
ADD https://raw.githubusercontent.com/kurukurumaware/DockerTools/master/extractlibrary /usr/local/bin/extractlibrary
RUN chmod +x /usr/local/bin/extractlibrary
RUN echo /usr/bin/socat > binlist
RUN echo /usr/sbin/pcscd >> binlist
RUN echo /usr/lib/pcsc/drivers/ifd-ccid.bundle/Contents/Linux/libccid.so >> binlist

RUN extractlibrary binlist /copydir
RUN cp --archive --parents --no-dereference /usr/lib/pcsc/drivers /copydir
COPY --from=Scard-start /copydir /copydir

# 本体
FROM alpine:3.12

COPY --from=B-CAS-build /copydir /

EXPOSE 40774
ENTRYPOINT ["/usr/local/bin/scard-server"]
CMD [""]