# This is copied out of the ngx_mruby repository in order to allow us to remove
# the redis gem that is bundled by default (and won't compile on our setups).
#
# Beyond that, this is some build config. It controls which mruby gems get bundled
# into the MRuby instance built into nginx.
#
# More detail can be found in the ngx_mruby wiki here:
# https://github.com/matsumotory/ngx_mruby/tree/master/docs/install#1-downloading-source-from-githubcom
MRuby::Build.new('host') do |conf|

  toolchain :gcc

  conf.gembox 'full-core'

  conf.cc do |cc|
    cc.flags << ENV['NGX_MRUBY_CFLAGS'] if ENV['NGX_MRUBY_CFLAGS']
  end

  conf.linker do |linker|
    linker.flags << ENV['NGX_MRUBY_LDFLAGS'] if ENV['NGX_MRUBY_LDFLAGS']

    # when using openssl from brew
    if RUBY_PLATFORM =~ /darwin/i
      linker.flags << '-L/usr/local/opt/openssl/lib -lcrypto'
    end
  end

  #
  # Recommended for ngx_mruby
  #
  conf.gem :github => 'iij/mruby-env'
  conf.gem :github => 'iij/mruby-dir'
  conf.gem :github => 'iij/mruby-digest'
  conf.gem :github => 'iij/mruby-process'
  conf.gem :github => 'mattn/mruby-json'
  conf.gem :github => 'mattn/mruby-onig-regexp'
  conf.gem :github => 'matsumotory/mruby-redis'
  conf.gem :github => 'matsumotory/mruby-vedis'
  conf.gem :github => 'matsumotory/mruby-userdata'
  conf.gem :github => 'matsumotory/mruby-uname'
  conf.gem :github => 'matsumotory/mruby-mutex'
  conf.gem :github => 'matsumotory/mruby-localmemcache'
  conf.gem :mgem => 'mruby-secure-random'

  # ngx_mruby extended class
  conf.gem './mrbgems/ngx_mruby_mrblib'
  conf.gem './mrbgems/rack-based-api'
  conf.gem './mrbgems/auto-ssl'

  # use memcached
  # conf.gem :github => 'matsumotory/mruby-memcached'

  # build error on travis ci 2014/12/01, commented out mruby-file-stat
  # conf.gem :github => 'ksss/mruby-file-stat'

  # use markdown on ngx_mruby
  # conf.gem :github => 'matsumotory/mruby-discount'

  # use mysql on ngx_mruby
  #conf.gem :github => 'mattn/mruby-mysql'

  # have GeoIPCity.dat
  # conf.gem :github => 'matsumotory/mruby-geoip'

  # Linux only for ngx_mruby
  # conf.gem :github => 'matsumotory/mruby-capability'
  # conf.gem :github => 'matsumotory/mruby-cgroup'

end

MRuby::Build.new('test') do |conf|
  # load specific toolchain settings

  # Gets set by the VS command prompts.
  if ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
    toolchain :visualcpp
  else
    toolchain :gcc
  end

  enable_debug

  conf.gem :github => 'matsumotory/mruby-simplehttp'
  conf.gem :github => 'matsumotory/mruby-httprequest'
  conf.gem :github => 'matsumotory/mruby-uname'
  conf.gem :github => 'matsumotory/mruby-simpletest'
  conf.gem :github => 'mattn/mruby-http'
  conf.gem :github => 'mattn/mruby-json'
  conf.gem :github => 'iij/mruby-env'

  # include the default GEMs
  conf.gembox 'full-core'
end