FROM alpine:latest
RUN apk --update --no-cache add iptables libcap
COPY ./entrypoint /
ENTRYPOINT ["/entrypoint"]
