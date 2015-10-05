# Base image heroku cedar stack v14
FROM heroku/cedar:14


# Remove all system python interpreters
RUN apt-get remove -y python3.4
RUN apt-get remove -y python3.4
RUN apt-get remove -y python3.4-minimal
RUN apt-get remove -y python3.4-minimal
RUN apt-get remove -y libpython3.4-minimal
RUN apt-get remove -y libpython3.4-minimal


# Make folder structure
RUN mkdir /app
RUN mkdir /app/.heroku
RUN mkdir /app/.heroku/vendor
WORKDIR /app/.heroku

RUN apt-get update
RUN apt-get install -y libsqlite3-dev sqlite

# Install python 3.4.3
ENV PATH /app/.heroku/vendor/bin:$PATH
ENV LD_LIBRARY_PATH /app/.heroku/vendor/lib/
ENV PYTHONPATH /app/.heroku/vendor/lib/python3.4/site-packages
RUN curl -s -L https://www.python.org/ftp/python/3.4.3/Python-3.4.3.tgz > Python-3.4.3.tgz
RUN tar zxvf Python-3.4.3.tgz
RUN rm Python-3.4.3.tgz
WORKDIR /app/.heroku/Python-3.4.3
RUN ./configure --prefix=/app/.heroku/vendor/ --enable-shared
RUN make install
WORKDIR /app/.heroku/vendor/bin
RUN cp python3 python
WORKDIR /app/.heroku
RUN rm -rf Python-3.4.3


# Install latest setup-tools and pip
RUN curl -s -L https://bootstrap.pypa.io/get-pip.py > get-pip.py
RUN python3 get-pip.py
RUN rm get-pip.py


# Install numpy
RUN pip install -v numpy


# Install ATLAS library and fortran compiler
RUN curl -s -L https://db.tt/osV4nSh0 > npscipy.tar.gz
RUN tar zxvf npscipy.tar.gz
RUN rm npscipy.tar.gz
ENV ATLAS /app/.heroku/vendor/lib/atlas-base/libatlas.a
ENV BLAS /app/.heroku/vendor/lib/atlas-base/atlas/libblas.a
ENV LAPACK /app/.heroku/vendor/lib/atlas-base/atlas/liblapack.a
ENV LD_LIBRARY_PATH /app/.heroku/vendor/lib/atlas-base:/app/.heroku/vendor/lib/atlas-base/atlas:$LD_LIBRARY_PATH
RUN apt-get update
RUN apt-get install -y gfortran


# Install scipy
RUN pip install -v scipy


# Install matplotlib
# RUN apt-get install -y libfreetype6-dev
# RUN apt-get install -y libpng-dev
RUN pip install -v matplotlib


# Install opencv with python bindings
RUN apt-get update
RUN apt-get install -y cmake
RUN curl -s -L https://github.com/Itseez/opencv/archive/3.0.0.zip > opencv-3.0.0.zip
RUN unzip opencv-3.0.0.zip
RUN rm opencv-3.0.0.zip
RUN curl -s -L https://github.com/Itseez/opencv_contrib/archive/3.0.0.zip > opencv_contrib-3.0.0.zip
RUN unzip opencv_contrib-3.0.0.zip
RUN rm opencv_contrib-3.0.0.zip
WORKDIR /app/.heroku/opencv-3.0.0
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/app/.heroku/vendor -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF -D BUILD_opencv_python=ON -D OPENCV_EXTRA_MODULES_PATH=/app/.heroku/opencv_contrib-3.0.0/modules .
RUN make install
WORKDIR /app/.heroku
RUN rm -rf opencv-3.0.0
RUN rm -rf opencv_contrib-3.0.0

RUN apt-get install -y squashfs-tools
