# nginx buildpack for Heroku

This buildpack allows you to run nginx on a Heroku dyno.

It has been powering [General Assembly's website](https://generalassemb.ly/) for several years.


## Features

* Downloads and builds nginx 1.21.4 from source
* Downloads and builds MRuby 2.2.4 from source
* Builds nginx with SSL, PCRE, and MRuby extensions
* Caches all builds for lightning-fast deploys

Note: SSL and PCRE packages are [already available](https://devcenter.heroku.com/articles/cedar-ubuntu-packages) on Heroku, so they don't need to be downloaded before building nginx.


## MRuby

MRuby is a lightweight version of Ruby optimized for use in embedded systems. The `ngx_mruby` module lets you use Ruby as an alternative to Lua for introducing dynamic scripting to nginx.

This blog post offers a taste of what you can do with MRuby in nginx:
http://hokstadconsulting.com/nginx/mruby-virtualhosts


## Using this buildpack

After adding the buildpack, `nginx` will be available on your path. But here comes the tricky part: Heroku sends HTTP traffic to a random port on any given dyno, indicated by the `PORT` environment variable. So in order for nginx to receive incoming requests, the `web` process in your `Procfile` needs to do the following:

1. Determine the current port.
1. Dynamically generate an `nginx.conf` file that listens on this port

  ```
  server {
    listen <%= ENV['PORT'] %>;
    ...
  }
  ```
1. Starts nginx with this generated config file

  ```
  nginx -c config/nginx.conf
  ```

Any application using this buildpack must handle all of this itself.

Additionally, this buildpack includes mruby, which requires ruby to be available
as part of the environment. When using this on Heroku, you must add the
`heroku/ruby` buildpack to your application, and ensure the project you deploy
has a Gemfile that installs `rake` in order to perform a successful build.

## Development

### Ubuntu

For maximum parity with Heroku's dynos, we recommend using Ubuntu or an Ubuntu virtual machine. See this article for all the details on Heroku's current stack:

https://devcenter.heroku.com/articles/stack

### OS X

In OS X, you can `bin/compile` locally like this:

```
BUILD_PREFIX=$PWD ./bin/compile $PWD/build $PWD/cache
```

If you try to build on OS X and have issues related to OpenSSL, make sure you've installed OpenSSL using Homebrew and then you could try the following command:
```
BUILD_PREFIX=$PWD NGINX_OPTIONS="--with-cc-opt=-I$(brew --prefix)/opt/openssl/include --with-ld-opt=-L$(brew --prefix)/opt/openssl/lib" bin/compile $PWD/build $PWD/cache
```
It's not the prettiest, but it _should_ sort out your issues. Basically, it provides an extra option to the nginx compilation which points it to the paths where OpenSSL is located, resolving the errors.


## Credits

This buildpack is based on ryandotsmith's [nginx-buildpack](https://github.com/ryandotsmith/nginx-buildpack). It has since been heavily adapted by General Assembly engineering for internal use. Since then, a ton of amazing features have been added to the original buildpack, so be sure to check that out if you're interested in running nginx on Heroku!
