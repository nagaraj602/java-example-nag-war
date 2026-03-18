FROM tomcat:10.1-jdk21

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR
COPY target/java-example-demo-1.0.0.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
