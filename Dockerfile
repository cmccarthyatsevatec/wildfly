# Use latest jboss/base-jdk:7 image as the base
FROM jboss/base-jdk:8

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 9.0.2.Final
ENV WILDFLY_SHA1 75738379f726c865d41e544e9b61f7b27d2853c7
ENV JBOSS_HOME /opt/jboss/wildfly
ENV AWS_ACCESS_KEY AKIAINXNJUKGBN6V47XA
ENV AWS_SECRET_ACCESS_KEY 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

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

# Expose the ports we're interested in
EXPOSE 8081
EXPOSE 9991

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
RUN /opt/jboss/wildfly/bin/add-user.sh admin Admin#70365 --silent
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-Djboss.socket.binding.port-offset=1"]

# Move the WAR file to be deployed
# ADD target/sevp.war /opt/jboss/wildfly/standalone/deployments/
