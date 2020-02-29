FROM vasuadari/collectd

RUN apt-get update && apt-get install -y supervisor

RUN apt-get update -yy && apt-get install -y nginx

RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
