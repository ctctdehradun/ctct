# blackfire CLI (with bundled agent)
RUN set -xeo pipefail \
    && version=$(php -r "echo PHP_MAJOR_VERSION, PHP_MINOR_VERSION;") \
    && curl -sSL -D - -A "Docker" -o /tmp/blackfire-probe.tar.gz https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/${version} \
    && curl -sSL -D - -A "Docker" -o /tmp/blackfire-client.tar.gz https://blackfire.io/api/v1/releases/client/linux_static/amd64 \
    && for file in /tmp/blackfire-*.tar.gz; do tar zxfp "${file}" -C /tmp; done \
    && for file in /tmp/blackfire-*.sha*; do echo "$(cat ${file})  ${file/.sha1/}"; done | sed 's/\.sha/.so/' | sha1sum -c - \
    && chmod +x /tmp/blackfire-*.so /tmp/blackfire \
    && mv /tmp/blackfire-*.so "$(php -r "echo ini_get('extension_dir');")/blackfire.so" \
    && mv /tmp/blackfire /bin/blackfire \
    && printf "extension=blackfire.so\n" > ${PHP_INI_DIR}/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire* \
    && php -m | grep "^blackfire$" > /dev/null

ENTRYPOINT ["blackfire"]
CMD ["help"]
