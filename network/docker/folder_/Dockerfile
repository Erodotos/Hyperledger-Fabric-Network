FROM python:3.7

WORKDIR /root/folder/py/

COPY /folder/ /root/folder/
RUN python -m pip install --upgrade pip
RUN python -m pip install grpcio
RUN python -m pip install grpcio-tools
RUN python /root/folder/py/server.py