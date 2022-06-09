FROM python:3.9-slim-buster
COPY requirements.txt /.

# Install python, nibabel and numpy (nibabel>=2.1 requires python>=3.5, ubuntu trusty has only python 3.4)
RUN apt-get update && \
apt-get --assume-yes install git && \
pip3 install --upgrade pip && \
pip3 install --no-cache-dir -r requirements.txt && \
pip3 install git+https://github.com/hed-standard/hed-python/@master

# ENV PYTHONPATH=""

COPY run.py /run.py

COPY version /version

ENTRYPOINT ["/run.py"]
