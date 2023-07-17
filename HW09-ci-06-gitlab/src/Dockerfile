FROM centos:7

RUN rpmkeys --import file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN yum install gcc openssl-devel bzip2-devel libffi-devel make wget -y

RUN wget https://www.python.org/ftp/python/3.7.17/Python-3.7.17.tgz
RUN tar xzf Python-3.7.17.tgz
RUN cd Python-3.7.17 && ./configure --enable-optimizations && make altinstall
RUN rm -r Python-3.7.17*
RUN ln -s /usr/local/bin/python3.7 /usr/bin/python3 && ln -s /usr/local/bin/pip3.7 /usr/bin/pip3
RUN pip3 install --upgrade wheel setuptools pip

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
RUN mkdir /python_api
COPY python-api.py /python_api/python-api.py
CMD ["python3", "/python_api/python-api.py"]
