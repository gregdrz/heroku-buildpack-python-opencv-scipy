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
RUN apt-get install python-opencv python-setuptools python-pip gfortran g++ liblapack-dev libsdl1.2-dev libsmpeg-dev mercurial
RUN apt-get install -y libsqlite3-dev sqlite

# Install latest setup-tools and pip
#RUN curl -s -L https://bootstrap.pypa.io/get-pip.py > get-pip.py
#RUN python2.7 get-pip.py
#RUN rm get-pip.py


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
#RUN apt-get install -y gfortran


# Install scipy
RUN pip install -v scipy


# Install matplotlib
# RUN apt-get install -y libfreetype6-dev
# RUN apt-get install -y libpng-dev
RUN pip install -v matplotlib


# Install opencv with python bindings
RUN apt-get update
RUN apt-get install -y cmake
RUN curl -s -L https://github.com/Itseez/opencv/archive/2.4.10.zip > opencv-2.4.10.zip
RUN unzip opencv-2.4.10.zip
RUN rm opencv-2.4.10.zip
WORKDIR /app/.heroku/opencv-2.4.10
RUN cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/app/.heroku/vendor -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_EXAMPLES=OFF -D BUILD_opencv_python=ON -D .
RUN make install
WORKDIR /app/.heroku
RUN rm -rf opencv-2.4.10


# Install pygame
RUN wget -O pygame.tar.gz https://bitbucket.org/pygame/pygame/get/6625feb3fc7f.tar.gz
RUN tar zxvf pygame.tar.gz
RUN rm pygame.tar.gz
RUN python2.7 pygame-pygame-6625feb3fc7f/setup.py -setuptools install
RUN rm -r pygame-pygame-6625feb3fc7f
