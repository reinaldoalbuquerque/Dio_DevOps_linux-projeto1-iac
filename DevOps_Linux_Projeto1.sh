#!/bin/bash

#Criando os grupos
echo "Criando grupos..."
GRPs=("GRP_ADM" "GRP_VEN" "GRP_SEC")
for grp in ${GRPs[@]}; do
  groupadd $grp
  echo "Grupo" $grp "criado..."
done

echo "Criando usuarios..."
USERS=("carlos,GRP_ADM" "maria,GRP_ADM" "joao,GRP_ADM" "debora,GRP_VEN" "sebastiana,GRP_VEN" "roberto,GRP_VEN" "josefina,GRP_SEC" "amanda,GRP_SEC" "rogerio,GRP_SEC")

#instalando openssl
apt-get -qq update
apt-get -qq install openssl -y

#Criando os usuarios, definindo senha e setando grupo
for i in ${USERS[@]}; do
  user=$(echo -e $i|cut -f1 -d,)
  grp=$(echo -e $i|cut -f2 -d,)
  useradd -m -s /bin/bash -p $(openssl passwd Senha123) -G $grp $user
  echo "Criando usuario " $user "..."
  echo "Adicionado usuario" $user "ao groupo" $grp
done

#Criando diretorios e definindo permissoes
echo "Criando diretorios..."
DIR=("publico" "adm" "ven" "sec")
for dir in ${DIR[@]}; do
  mkdir -p /$dir
  echo "Diretorio" $dir "criado..."
  echo "Definindo permissoes..."
  if [ $dir = "publico" ]
  then
     echo "Permissoes da pasta publica..."
     chown root.root /publico
     chmod 777 /publico
     continue
  fi
  echo "Permissoes da pasta" $dir "definida..."
  chown root.$(echo "GRP_"$dir|tr '[:lower:]' '[:upper:]') /$dir
  chmod 770 /$dir
done
