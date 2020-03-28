#!/bin/bash
FILE="Write here path of text file"

echo "---------------------------"

LIGNE_DEBUT_TABLE_DES_MATIERE="$(gsed -n '/\/\/-----table des matieres-----\/\//=' $FILE)"
LIGNE_FIN_TABLE_DES_MATIERE=$(gsed -n '/\/\/--@table des matieres@--\/\//=' $FILE)

LIGNE_A_EFFACER_DEBUT=$(($LIGNE_DEBUT_TABLE_DES_MATIERE+1))
LIGNE_A_EFFACER_FIN=$(($LIGNE_FIN_TABLE_DES_MATIERE-1))

gsed -i "${LIGNE_A_EFFACER_DEBUT},${LIGNE_A_EFFACER_FIN}d" $FILE


#Firt get the title of the sections
LIGNE_SECTION=()
LIGNE_SECTION+=($(gsed -n '/\/\/\@/=' "$FILE"))
NOMBRE_ELEMENT_ARRAY="${#LIGNE_SECTION[@]}"

LIGNE_FIN_TABLE_DES_MATIERE=$(gsed -n '/\/\/--@table des matieres@--\/\//=' $FILE)
LIGNE_DEBUT_TABLE_DES_MATIERE="$(gsed -n '/\/\/-----table des matieres-----\/\//=' $FILE)"

#boucle mettre les titres de sections dans une liste
j=0
	until [ ! $j -lt $NOMBRE_ELEMENT_ARRAY ]
	do

	TITRE_SECTION_ARROBAS[$j]=$(gsed -n "${LIGNE_SECTION[$j]} p" "$FILE")
	TITRE_SECTION[$j]=$(echo "${TITRE_SECTION_ARROBAS[$j]}" | gsed -e 's/@//g')

	echo "${TITRE_SECTION[$j]}"

j=`expr $j + 1`
done
#
k=0
		until [ ! $k -lt $NOMBRE_ELEMENT_ARRAY ]
	do
		gsed -i "$((${k}+${LIGNE_DEBUT_TABLE_DES_MATIERE})) a ${TITRE_SECTION[$k]}" $FILE

k=`expr $k + 1`
done

#Second write the conten
LIGNE_SECTION_SECOND=()
LIGNE_SECTION_SECOND+=($(gsed -n '/\/\/\@/=' "$FILE"))
LIGNE_DEBUT_TABLE_DES_MATIERE_SECOND="$(gsed -n '/\/\/-----table des matieres-----\/\//=' $FILE)"
PLUS_UN_TABLE_DES_MATIERE=$(($LIGNE_DEBUT_TABLE_DES_MATIERE_SECOND+1))

#boucle mettre les numéro de ligne dans la table des matières
m=0
		until [ ! $m -lt $NOMBRE_ELEMENT_ARRAY ]
	do
	gsed -i "$((${m}+${PLUS_UN_TABLE_DES_MATIERE}))s/.*/\/\/Ligne : ${LIGNE_SECTION_SECOND[$m]}..........&/" $FILE
	
	#$((${k}+${LIGNE_DEBUT_TABLE_DES_MATIERE}))
	#gsed -i '8s/.*/boubou&/' $FILE

m=`expr $m + 1`
done
echo "---------------------------"
echo "Table des matières compilée"
echo "---------------------------"
