#!/bin/bash

# Nome: padronização de segurança das vps
# Objetivo: Atualizar o sistema baseado em Debian, criar as regras de firewall, e liberar portas

echo "===> Atualizando lista de pacotes..."
sudo apt update -y

echo "===> Atualizando pacotes instalados..."
apt upgrade && apt full-upgrade -y

echo "===> Removendo pacotes desnecessários..."
apt autoremove -y

echo "===> Instalação do Wazuh-agent"
wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.12.0-1_amd64.deb && sudo WAZUH_MANAGER='191.182.200.30' WAZUH_AGENT_GROUP='VPS-ACERTI' dpkg -i ./wazuh-agent_4.12.0-1_amd64.deb

echo "===> Reload Daemon"
systemctl daemon-reload

echo "===> Habilitando Wazuh-agent"
systemctl enable wazuh-agent

echo "===> Startando Wazuh-agent"
systemctl start wazuh-agent

echo "===> Instalação do Firewalld"
apt install firewalld -y

echo "==> Habilitando firewalld"
systemctl enable --now firewalld

echo "===> Liberar serviço http"
firewall-cmd --zone=public --permanent --zone=public --add-service=http

echo "===> Adicionar serviço https"
firewall-cmd --zone=public --permanent --zone=public --add-service=https

echo "===> Aplicando Regras"
firewall-cmd --reload

#regras recarregadas para não haver periodo de instabilidade nos serviços

echo "===> Permitindo SSH apenas da Acerti"
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="191.182.200.30" port protocol="tcp" port="4987" accept'

echo "===> Permitir ping apenas da Acerti"
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="191.182.200.30" icmp-type name="echo-request" accept'

echo "===> Bloquear ping externo"
firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" icmp-type name="echo-request" drop'

echo "===> configurado firewall, bloqueio SSH externo"
firewall-cmd --zone=public --remove-service=ssh --permanent

echo "===> Recarregando firewalld para aplicar regras"
firewall-cmd --reload

echo "===> Desativando ufw"
systemctl disable ufw

echo "===> Reload Daemon"
systemctl daemon-reload

