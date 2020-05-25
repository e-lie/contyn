# installer SSH
apt update && apt install -yqq openssh-server sudo

## Attention copiez cette commande bien correctement
# configurer sudo pour être sans password
sed -i 's@\(%sudo.*\)ALL@\1 NOPASSWD: ALL@' /etc/sudoers

# Créer votre utilisateur de connexion
useradd -m -s /bin/bash -G sudo stagiaire

# Définission du mot de passe
passwd stagiaire

exit