FROM ubuntu:latest
RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential

COPY ./demoapp /demoapp
WORKDIR /demoapp

RUN pip install -r /demoapp/requirements.txt

CMD ["python", "demo.py"]

