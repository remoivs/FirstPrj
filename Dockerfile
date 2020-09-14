FROM devopsedu/webapp:latest

COPY index.php /var/www/html/

RUN apt update && \
    apt install -y php

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
