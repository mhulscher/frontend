You can change the behaviour of this image by setting one or more environment variables.

## Confd

Environment variable | Default value | Description
--- | --- | ---
`CONFD_LOG_LEVEL` | `info` | Defines the log level of confd, which is used to generate the nginx vhost configuration file from a template.

## Nginx

Environment variable | Default value | Description
--- | --- | ---
`NGX_DOCUMENT_ROOT` | /var/www/html | Defines the document root.
`NGX_PROXY` | absent | Toggles whether Nginx should derive the real ip-address from the X-Real-IP header. Lookups are **not** done recursive. Only a single substition will take place. Only use this if your container is running behind a reverse proxy that you trust.
`NGX_TLS` | absent | This will be set to 1, which will enable TLS inside nginx, but only if the files `/tls/tls.key` and `/tls/tls.crt` are found inside the container. Use a volume mount, Kubernetes configmap/secret or something similar.

## Application

By convention your frontend application will probably require an environment file called `env.js` to reside in the document root. Before nginx is started, any variable definitions inside the `env.js` file will be replaced with environment variables. For example:

Your `env.js` contains the following snippet:
```
{
  api_url: '${API_URL}'
}
```

You start your container with the following environment variable: `API_URL=https://my-api.tld`. Before nginx is started, the `env.js` will be edited to this:
```
{
  api_url: 'https://my-api.tld'
}
```

You can change the path of the configuration file, `env.js` by default, by setting the `ENVIRONMENT_FILE` variable. The path should be relative to the document root.

## Extending functionality

You can have a look at the [nginx vhost template](../files/confd/templates/www.conf.tmpl). You can override this with your own template, if you'd like. You can include new NGX_* environment variables to use inside your template and pass them to your container.

For example, inside a Dockerfile in your project, do this:

```
COPY nginx/www.conf.tmpl /etc/confd/templates/www.conf.tmpl
ENV NGX_MY_COOL_FEATURE=1
```
