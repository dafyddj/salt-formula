# -*- coding: utf-8 -*-
# vim: ft=yaml
---
salt:
  master:
    fileserver_backend:
      - rootfs
    file_roots:
      base:
        - /srv/salt
    pillar_roots:
      base:
        - /srv/pillar
    ext_pillar:
      - cmd_yaml: cat /etc/salt/yaml
      - git:
          - develop https://gitserver/git-pillar.git:
              - env: base
      - reclass:
          inventory_base_uri: /etc/reclass
  minion:
    master: localhost
    fileserver_backend:
      - rootfs
    file_roots:
      base:
        - /srv/salt
    pillar_roots:
      base:
        - /srv/pillar
