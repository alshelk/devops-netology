#!/usr/bin/env bash

cd /tmp/Python-3.8.10
./configure --enable-optimizations
make altinstall
alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.8 1 && alternatives --set python3 /usr/local/bin/python3.8 && echo "2" | alternatives --config python
/usr/local/bin/python3.8 -m pip install --upgrade pip
alternatives --install /usr/bin/pip3 pip3 /usr/local/bin/pip3.8 1 && alternatives --set pip /usr/local/bin/pip3.8
