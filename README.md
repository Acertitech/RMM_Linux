# 🛡️ Padronização de Segurança das VPS

Este script tem como objetivo aplicar uma configuração de segurança básica em servidores **Debian/Ubuntu**, incluindo:

- Atualização do sistema
- Instalação do agente Wazuh
- Configuração de firewall com `firewalld`
- Regras de segurança para acesso SSH e ICMP (ping)

---

## ⚙️ Requisitos

- Distribuição baseada em **Debian/Ubuntu**
- Acesso com privilégios de **root** ou via `sudo`
- Conexão com a internet

---

## 📦 O que o script faz?

1. Atualiza o sistema:
   - `apt update`, `apt upgrade`, e `apt autoremove`

2. Instala o **Wazuh Agent**:
   - Baixa o pacote `.deb`
   - Define o IP do servidor Wazuh: `191.182.200.30`
   - Grupo de agente: `VPS-ACERTI`
   - Habilita e inicia o serviço

3. Instala e configura o **firewalld**:
   - Habilita e inicia o `firewalld`
   - Libera portas HTTP (80) e HTTPS (443)
   - Cria regras personalizadas:
     - Libera SSH **somente** para o IP `191.182.200.30`
     - Permite ping apenas deste IP
     - Bloqueia ping de qualquer outro IP
     - Remove o serviço SSH do acesso público
       
4. Instala o **RMM Agent**:
     - Site Acerti VPS 

5. Finaliza:
   - Recarrega as regras do `firewalld`
   - Desativa o firewall `ufw` (se estiver ativo)
   - Recarrega os daemons do `systemd`

---

## 🚀 Como usar

1. Copie o script para um arquivo, por exemplo:

```bash
sudo chmod +x install_agent.sh
sudo chmod +x padroniza_vps.sh
sudo ./padroniza_vps.sh
sudo ./install_agent.sh
