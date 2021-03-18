#cloud-config
ssh_pwauth: True
hostname: ${hostname}

users:
  - name: tom
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDf4B2+vczTbYKl5vkGN/akXKPjFCXzKfYRw2JG6WzTurXc2kZG8qT9J4TeRr2CgzzcjzAWN7e61hJrdt/9vt2+fk/MlsEOkeXRtl0vnrDGJzM5SrtWc4ORIdhpODDXHbu+Jf0sDOQ+k/dPzE0ZKyfcirf/GNpELyHoTgHvinQJzQdIDghX+V1JrxbJujCzKgCPypDlSd8yMdDzjHRO7MRnIO+zhb71G8MI2yhA2hYHGcOLXRhn46nAxWTb0GYd7rDZGNK1cayzQ+h/OBjeJgzSSrTzj2PZxOO47d6QiLCJf1o+HWEh7Gkh7KcXZkfa908V/HRK5hx/b9eJDidf2rZ9R5tLKXjNleG7F6wU07NpjaSFOHoQ8f3EHWmfia94G9m+87s/O0cmHHMp0psPDlkSgJ45W0rLWHDdIMZLMzuCW0NfaOeI0iXFmnJOUTuUHKm4tO0Qr5d0DaUvY/Fvut9NT/5UJjD8k3mJHKHFRwSUtAEsPUdtERufaHModDFQuoM= tom@ubuntu
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash
    groups: wheel

runcmd:
    - mkdir -p /etc/ansible/facts.d
    - printf '[kubernetes]\nmode=%s\n' $(sed 's/..$//' <<< ${hostname}) >/etc/ansible/facts.d/cloudinit.fact

growpart:
  mode: auto
  devices: ['/']

power_state:
    mode: reboot
