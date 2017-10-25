FROM ubuntu:latest
MAINTAINER Sebastiaan Hilbers "bashilbers@gmail.com"

# env
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2

# Update the repos
RUN apt-get -y update && apt-get -y upgrade

# Install base packages
RUN export LANG=en_US.UTF-8 && \
    export DEBIAN_FRONTEND="noninteractive" && \
    apt-get install -y --no-install-recommends git zip \
    curl apache2 cron php7.0 libapache2-mod-php7.0 \
    php7.0-mysql php7.0-curl php7.0-zip php7.0-gd php7.0-mbstring php7.0-dom

# Clean
RUN apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

# Configure apache
RUN a2enmod rewrite
RUN a2enmod headers
RUN rm -rf /etc/apache2/sites-enabled/*
ADD vhost.conf /etc/apache2/sites-enabled/000-vhost.conf
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN echo "ServerSignature Off" >> /etc/apache2/apache2.conf
RUN rm -rf /var/www
COPY www /var/www
RUN chown -R www-data:www-data /var/www
ADD apache.sh /apache.sh

# Configure Cron
RUN touch /var/log/cron.log
RUN ln -sf /proc/1/fd/1 /var/log/cron.log
RUN rm -rf /etc/cron.*
ADD crontab /etc/crontab
RUN chmod 0644 /etc/crontab

# Expose apache and set entrypoint
EXPOSE 80
CMD ["/apache.sh"]

WORKDIR /var/www
