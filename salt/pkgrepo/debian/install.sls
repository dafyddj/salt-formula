# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "salt/map.jinja" import salt_settings with context %}

{% set salt_3008_or_newer = grains["saltversioninfo"] >= [3008] -%}

salt-pkgrepo-install-saltstack-debian-keyring:
  file.managed:
    - name: /etc/apt/keyrings/salt-archive-keyring.pgp
    - source: {{ salt_settings.pkgrepo_keyring }}
    - source_hash: {{ salt_settings.pkgrepo_keyring_hash }}
    - require_in:
      - pkgrepo: salt-pkgrepo-install-saltstack-debian

salt-pkgrepo-install-saltstack-debian-remove-old-repo-file:
  file.absent:
    - names:
{%- if salt_3008_or_newer %}
      - /etc/apt/sources.list.d/salt.list
{%- endif %}
      - /etc/apt/sources.list.d/saltstack.list
    - require_in:
      - pkgrepo: salt-pkgrepo-install-saltstack-debian

{% set source_ext = "sources" if salt_3008_or_newer else "list" -%}

salt-pkgrepo-install-saltstack-debian:
  pkgrepo.managed:
    - humanname: Salt Project
    - name: {{ salt_settings.pkgrepo }}
    - file: /etc/apt/sources.list.d/salt.{{ source_ext }}
    {% if salt_settings.get('key_url') is not none %}
    - key_url: {{ salt_settings.key_url }}
    {% endif %}
    - clean_file: True
    # Order: 3 because we can't put a require_in on "pkg: salt-{master,minion}"
    # because we don't know if they are used.
    - order: 3
