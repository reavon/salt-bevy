---
# salt state file to define an interactive user, used in development.
#
{% if salt['grains.get']('virtual', 'physical') == 'VirtualBox' %}
  {% set make_uid = salt['config.get']('my_linux_uid', -2) | int %}  {# does not force uid if blank #}
  {% set make_gid = salt['config.get']('my_linux_gid', -2) | int %}
{% else %}
  {% set make_uid = -3 %}
  {% set make_gid = -3 %}
{% endif %}
{% if grains['os'] == 'Windows' %}
  {% set my_user = salt['pillar.get']('my_windows_user', 'None') %}
{% else %}
  {% set my_user = salt['pillar.get']('my_linux_user', 'None') %}
{% endif %}
{% set home = 'C:/Users/' if grains['os'] == "Windows" else '/Users/' if grains['os'] == 'MacOS' else '/home/' %}
{% set users_group = 'Users' if grains['os'] == "Windows" else 'users' %}

{% if my_user != 'None' %}
 {% if not salt['file.directory_exists'](home + my_user + "/Desktop") %} {# do not do this on user's workstation #}
staff:
  group:
  - present

{{ my_user }}:
  user:
    - present
    - groups:
    {% if grains['os'] == 'Windows' %}
      - Administrators {% else %}
      - sudo{% endif %}
    - optional_groups:
      - {{ users_group }}
      - www-data
      - staff
      - dialout
      - wireshark
    - home: {{ home }}{{ my_user }}'
    {% if grains['os'] == 'Windows' %}
    - password: {{ salt['pillar.get']('my_windows_password') }}
    - win_profile: C:/Users/{{ my_user }}
    {% else %}
    - shell: /bin/bash
    - password: "{{ salt['pillar.get']('linux_password_hash') }}"
    - enforce_password: {{ salt['config.get']('force_linux_user_password', false) }}
    {% if make_uid > 0 %}- uid: {{ make_uid }} {% endif %}
    {% endif %}

  {% if grains['os'] in ['Windows', 'MacOS'] %}
{{ home }}{{ my_user }}:
  file.directory:
    - user: {{ my_user }}
  {% endif %}
 {% endif %}
{% endif %}
...
