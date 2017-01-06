This is not an attempt to produce a minimal swift docker file. I needed a docker container to run my kitura project.

Your ```Dockerfile``` should look something like this:

```
FROM mkunze/swift-ubuntu

WORKDIR /project

COPY . /project

RUN swift build --configuration release

EXPOSE 8080

ENTRYPOINT [".build/release/project"]
```
