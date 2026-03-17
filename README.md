# java-example-nag-war
└──> source code for building WAR application

---

# 📦 Spring Boot WAR Application (Java 21+)

This is a minimal Spring Boot application that:

* Uses Java 21+
* Packaged as a **WAR file**
* Deployable to **external Tomcat**
* Runs on **Tomcat default port (8080)**
* Can be built using **Maven or Gradle**
* Can be containerized using **Tomcat Docker image**
* Can be deployed to **Kubernetes**

---

# 📁 Project Structure

```
java-example-nag-war/
 ├── src/main/java/com/example/demo/DemoApplication.java
 ├── src/main/resources/application.yml
 ├── pom.xml
 ├── build.gradle
 ├── settings.gradle
 ├── Dockerfile
 └── k8s-deployment.yaml
```

---

# ☕ Java Code

## DemoApplication.java

```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class DemoApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(DemoApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @GetMapping("/")
    public String home() {
        return "Hello, Spring Boot WAR deployed on Tomcat!";
    }
}
```

---

# ⚙️ application.yml

```yaml
server:
  port: 8085
```

⚠️ Note: When deployed to external Tomcat, **Tomcat's port (8080)** will be used instead.

---

# 📦 pom.xml (Maven - WAR)

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://www.m...">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>java-example-nag-war</artifactId>
    <version>java-example-demo-1.0.0</version>
    <packaging>war</packaging>

    <name>java-example-nag-war</name>
    <description>Spring Boot WAR Application</description>

    <properties>
        <java.version>21</java.version>
        <spring.boot.version>3.3.0</spring.boot.version>
    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-dependencies</artifactId>
                <version>${spring.boot.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <dependencies>

        <!-- Web -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <!-- External Tomcat (provided) -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
            <scope>provided</scope>
        </dependency>

    </dependencies>

    <build>
        <finalName>java-example-demo-1.0.0</finalName>

        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <version>${spring.boot.version}</version>
            </plugin>
        </plugins>
    </build>

</project>
```

---

# ⚙️ build.gradle (Gradle - WAR)

```groovy
plugins {
    id 'java'
    id 'war'
    id 'org.springframework.boot' version '3.3.0'
    id 'io.spring.dependency-management' version '1.1.6'
}

group = 'com.example'
version = 'java-example-demo-1.0.0'

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'

    providedRuntime 'org.springframework.boot:spring-boot-starter-tomcat'
}

bootWar {
    archiveFileName = 'java-example-demo-1.0.0.war'
}

tasks.named('test') {
    useJUnitPlatform()
}
```

---

# ⚙️ settings.gradle

```groovy
rootProject.name = 'java-example-nag-war'
```

---

# 🐳 Dockerfile (Tomcat-based)

```dockerfile
FROM tomcat:10.1-jdk21

# Clean default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR
COPY target/java-example-demo-1.0.0.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
```

---

# ☸️ Kubernetes YAML

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-example-nag-war
spec:
  replicas: 1
  selector:
    matchLabels:
      app: java-example-nag-war
  template:
    metadata:
      labels:
        app: java-example-nag-war
    spec:
      containers:
        - name: tomcat
          image: your-dockerhub-username/java-example-nag-war:latest
          ports:
            - containerPort: 8080

---
apiVersion: v1
kind: Service
metadata:
  name: java-example-nag-war-service
spec:
  type: NodePort
  selector:
    app: java-example-nag-war
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30007
```

---

# 🚀 How to Use

## 1️⃣ Build WAR using Maven

```bash
mvn clean package
```

Output:

```
target/java-example-demo-1.0.0.war
```

---

## 2️⃣ Build WAR using Gradle

```bash
gradle clean build
```

Output:

```
build/libs/java-example-demo-1.0.0.war
```

---

## 3️⃣ Deploy to External Tomcat

Copy WAR file into:

```
/opt/tomcat/webapps/
```

Start Tomcat:

```
./startup.sh
```

Access:

```
http://<server-ip>:8080/
```

---

## 4️⃣ Build Docker Image

```bash
docker build -t your-dockerhub-username/java-example-nag-war:latest .
```

---

## 5️⃣ Run Docker Container

```bash
docker run -d -p 8080:8080 your-dockerhub-username/java-example-nag-war:latest
```

---

## 6️⃣ Deploy to Kubernetes

```bash
kubectl apply -f k8s-deployment.yaml
```

Check:

```bash
kubectl get pods
kubectl get svc
```

---

# ✅ Output

Open:

```
http://<server-ip>:8080/
```

You should see:

```
Hello, Spring Boot WAR deployed on Tomcat!
```

---
