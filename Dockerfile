FROM girder/girder

EXPOSE 8080

ENTRYPOINT ["girder-server", "-d", "mongodb://54.183.227.160:27017/girder"]
