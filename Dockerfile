FROM centos
MAINTAINER langdon <langdon@fedoraproject.org>
#Derived from Vaclav Pavlin <vpavlin@redhat.com>; https://github.com/vpavlin/atomicapp-run

RUN yum -y update
RUN yum -y install python python-pip docker-io kubernetes && yum clean all

ADD requirements.txt setup.py /opt/atomicapp/
ADD ./atomicapp /opt/atomicapp/atomicapp/
RUN chmod u+x /opt/atomicapp/setup.py && cd /opt/atomicapp && ./setup.py install

WORKDIR /application-entity
VOLUME /application-entity

LABEL RUN docker run --rm -it --privileged --net=host -v ${PWD}:/atomicapp -v /run:/run -v /:/host -v ${PWD}:/application-entity --name NAME -e NAME=NAME -e IMAGE=IMAGE IMAGE -v run /atomicapp
LABEL INSTALL docker run --rm -it --privileged -v /run:/run -v ${PWD}:/atomicapp -v /:/host -v ${PWD}:/application-entity -e IMAGE=IMAGE -e NAME=NAME --name NAME IMAGE -v install --path /atomicapp /application-entity

#CMD  atomicapp -h
ENTRYPOINT ["/usr/bin/atomicapp"]
