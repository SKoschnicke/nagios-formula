{% from "nagios/map.jinja" import map with context %}

nagios-server-package:
  pkg:
    - installed
    - name: {{ map.nagios_server }}

nagios-service:
  service:
    - running
    - name: {{ map.nagios_service }}
    - enable: true

{% set hosts = salt['pillar.get']('nagios:server:hosts', {}) -%}

{%- for key, host in hosts.iteritems() %}
/etc/nagios3/conf.d/{{host.hostname}}_nagios2.cfg:
  file.managed:
    - source: salt://nagios/server/files/host.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: nagios-service
    - context:
      hostname: {{ host.hostname }}
      alias: {{ host.alias }}
      address: {{ host.address }}
{%- endfor %}
