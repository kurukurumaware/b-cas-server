# SMART-CARD server 
# Build environment x86_64
FROM kurukurumaware/part-scard-start AS Scard-start

# Smart Card Server
FROM alpine:3.12 AS B-CAS-build

WORKDIR /tmp
RUN set -eux \
    && apk update \
    && apk add --no-cache bash bash ccid socat
ADD https://raw.githubusercontent.com/kurukurumaware/extlibcp/master/extlibcp /usr/local/bin/extlibcp
RUN chmod +x /usr/local/bin/extlibcp

RUN echo "\
    /usr/bin/socat \
    /usr/sbin/pcscd \
    /usr/lib/pcsc/drivers/ifd-ccid.bundle/Contents/Linux/libccid.so \
    "| extlibcp /copydir

RUN cp --archive --parents --no-dereference /usr/lib/pcsc/drivers /copydir
COPY --from=Scard-start /copydir /copydir

# 本体
FROM alpine:3.12

COPY --from=B-CAS-build /copydir /

EXPOSE 40774
ENTRYPOINT ["/usr/local/bin/scard-server"]
CMD [""]