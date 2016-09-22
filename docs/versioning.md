CI/CD will only push Docker images of the master-branch to the registy. Per image, you will find the following tags available. The latest tagged stable version is 0.0.1.

```
docker1-registry.twobridges.io/frontend:latest
docker1-registry.twobridges.io/frontend:0.0.1
docker1-registry.twobridges.io/frontend:0
```

As you can see, there is a -latest, -0.0.1 (full version) and -0 (major version). **You are recommended to use the major version.** Newer versions of the same major will not include breaking changes.
