# Nothin' but Serf

![Hashicorp Serf][serf-192]

## But Why Though

I needed a minimal installation of [hashicorp/serf][serf-src], downloaded and verified from the [official Serf downloads][serf-bin] page. This serves as a simple, containerized installation source.

## Docker

To install into an image via `Dockerfile`:

```dockerfile
COPY --from=overneath/serf:0.8 /opt/local/ /usr/local/
```

## LinuxKit

To underlay in [minimalist LinuxKit composition](linuxkit.yml):

```yaml
kernel:
  # ...
init:
  - linuxkit/init:v0.6
  # ...
  - overneath/serf:0.8
onboot:
  # ...
services:
  # ...
  - name: serf
    image: alpine:3.7
    binds:
      - /etc/resolv.conf:/etc/resolv.conf
      - /run/config/serf:/etc/serf
      - /opt/local:/usr/local
      - /var/lib/serf:/var/lib/serf
    command: [/usr/local/bin/serf, agent, -config-dir=/etc/serf, -tags-file=/var/lib/serf/tags.json]
    runtime:
      mkdir:
        - /run/config/serf
        - /var/lib/serf
```

To verify that the LinuxKit build is working, invoke via `linuxkit run` and then after the OS comes up in the getty console:

```shell
nsenter -a -t 1 /opt/local/bin/serf members
```

E.g. (in the `linuxkit run` console):

```
(ns: getty) linuxkit-025000000006:~# nsenter -a -t 1 /opt/local/bin/serf members
linuxkit-025000000006  127.0.0.1:7946  alive
(ns: getty) linuxkit-025000000006:~#
(ns: getty) linuxkit-025000000006:~# poweroff
The system is going down NOW!0006:~# ^[[20;38R
Sent SIGTERM to all processes
Sent SIGKILL to all processes
Requesting system poweroff
[   17.369562] ACPI: Preparing to enter system sleep state S5
[   17.371389] reboot: Power down
```

---

[serf-192]: https://github.com/hashicorp/serf/raw/3d6a974239f0b515c87479d5beefe575ad866805/website/source/assets/images/favicons/android-chrome-192x192.png "Hashicorp Serf"
[serf-bin]: https://www.serf.io/downloads.html "Serf Downloads"
[serf-src]: https://github.com/hashicorp/serf "Serf on Github"
[serf-by-dweomer]: https://hub.docker.com/r/dweomer/serf
