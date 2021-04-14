  
FROM centos:7 as server-image
RUN mkdir -p /var/www/html/custum-repo
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN yum --downloadonly --downloaddir=/var/www/html/custum-repo -y install httpd
RUN yum -y install httpd createrepo
RUN createrepo /var/www/html/custum-repo
COPY ./custum.repo /etc/yum.repos.d/custum.repo
RUN sed -i 's/#ServerName www.example.com:80/ServerName 192.168.1.240:80/g' /etc/httpd/conf/httpd.conf
RUN sed -i 's/ServerAdmin root@localhost/ServerAdmin root@192.168.1.240/g' /etc/httpd/conf/httpd.conf
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
EXPOSE 80


  
FROM centos:7 as client-image
RUN yum-config-manager --add-repo=http://192.168.1.240:8899/custum-repo
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
RUN yum -y install httpd
