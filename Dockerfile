FROM tomcat:10.1-jdk17
WORKDIR /usr/local/tomcat

# Clean default webapps
RUN rm -rf webapps/*

# Copy your source web files into Tomcat's deployment folder
COPY src/main/webapp/ webapps/ROOT/

EXPOSE 8080
CMD ["catalina.sh", "run"]
