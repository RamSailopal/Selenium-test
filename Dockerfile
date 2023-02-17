FROM docker.io/ubuntu
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade -y && \
    apt install -y curl gpg python3-pip python3-venv unzip apache2 && \
    curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt update && \
    apt install -y google-chrome-stable && \
    cd /tmp && \
    wget https://chromedriver.storage.googleapis.com/110.0.5481.30/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver_linux64.zip && \
    mv chromedriver /usr/bin/chromedriver && \
    chown root: /usr/bin/chromedriver && \
    chmod 755 /usr/bin/chromedriver && \
    pip install selenium && \
    a2enmod proxy && \
    a2enmod proxy_http && \
    a2enmod proxy_balancer && \
    a2enmod lbmethod_byrequests
WORKDIR /home/tests
ENTRYPOINT cp 000-default.conf /etc/apache2/sites-enabled/000-default.conf && service apache2 restart && python3 test.py
