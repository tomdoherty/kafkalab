[all]
%{ for host in hosts ~}
${host.network_interface.0.addresses.0}
%{ endfor ~}
