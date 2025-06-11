ARG OS_VERSION="3.22"
# ignored in this Dockerfile
ARG PLATFORM="amd64"
ARG TAG_PREFIX=""
ARG NAMESPACE="local"
FROM alpine:${OS_VERSION}

ARG REQUIRED_PKGS="\
  ruby \
  ruby-bigdecimal \
  ruby-racc \
"

RUN apk add --no-cache $REQUIRED_PKGS

ARG TRIAGE_VERSION="1.44.5"

RUN gem install gitlab-triage -v ${TRIAGE_VERSION} \
    --clear-source \
    --no-document \
    --no-update-sources \
  && rm -rf \
    /usr/lib/ruby/gems/*/cache \
    /usr/lib/ruby/gems/*/doc \
    /usr/lib/ruby/gems/*/gems/*/test \
    /usr/lib/ruby/gems/*/gems/*/doc \
    /usr/lib/ruby/gems/*/gems/*/CHANGE*.md \
    /usr/lib/ruby/gems/*/gems/*/CODE*.md \
    /usr/lib/ruby/gems/*/gems/*/CONTRIBUT*.md \
    /usr/lib/ruby/gems/*/gems/*/.gitlab*

