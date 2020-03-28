#!/bin/bash
FILE="/Users/julien/Documents/notes_de_cours_et_cours/module_cours/web/styles/style_livre_html.styl"

echo "---------------------------"

FIRST_LINE_OF_TABLE_OF_CONTENT="$(gsed -n '/\/\/-----Table of content-----\/\//=' $FILE)"
LAST_LINE_OF_TABLE_OF_CONTENT=$(gsed -n '/\/\/--@Table of content@--\/\//=' $FILE)

FIRST_LINE_TO_DELETE=$(($FIRST_LINE_OF_TABLE_OF_CONTENT+1))
LAST_LINE_TO_DELETE=$(($LAST_LINE_OF_TABLE_OF_CONTENT-1))

gsed -i "${FIRST_LINE_TO_DELETE},${LAST_LINE_TO_DELETE}d" $FILE


#Firt get the title of the sections
LINE_NUMBER_OF_COMMENTED_SECTION=()
LINE_NUMBER_OF_COMMENTED_SECTION+=($(gsed -n '/\/\/\@/=' "$FILE"))
TOTAL_ELEMENT_ARRAY_LINE_NUMBER_OF_COMMENTED_SECTION="${#LINE_NUMBER_OF_COMMENTED_SECTION[@]}"

LAST_LINE_OF_TABLE_OF_CONTENT=$(gsed -n '/\/\/--@Table of content@--\/\//=' $FILE)
FIRST_LINE_OF_TABLE_OF_CONTENT="$(gsed -n '/\/\/-----Table of content-----\/\//=' $FILE)"

#boucle mettre les titres de sections dans une liste
j=0
	until [ ! $j -lt $TOTAL_ELEMENT_ARRAY_LINE_NUMBER_OF_COMMENTED_SECTION ]
	do

	SECTION_TITLE_WITH_ARROBAS[$j]=$(gsed -n "${LINE_NUMBER_OF_COMMENTED_SECTION[$j]} p" "$FILE")
	SECTION_TITLE_WITHOUT_ARROBAS[$j]=$(echo "${SECTION_TITLE_WITH_ARROBAS[$j]}" | gsed -e 's/@//g')

	echo "${SECTION_TITLE_WITHOUT_ARROBAS[$j]}"

j=`expr $j + 1`
done
#
k=0
		until [ ! $k -lt $TOTAL_ELEMENT_ARRAY_LINE_NUMBER_OF_COMMENTED_SECTION ]
	do
		gsed -i "$((${k}+${FIRST_LINE_OF_TABLE_OF_CONTENT})) a ${SECTION_TITLE_WITHOUT_ARROBAS[$k]}" $FILE

k=`expr $k + 1`
done

#Second write the content
LINE_NUMBER_OF_COMMENTED_SECOND_SECTION=()
LINE_NUMBER_OF_COMMENTED_SECOND_SECTION+=($(gsed -n '/\/\/\@/=' "$FILE"))
FIRST_LINE_OF_TABLE_OF_CONTENT_SECOND="$(gsed -n '/\/\/-----Table of content-----\/\//=' $FILE)"
ADD_ONE_TO_FIRST_LINE_OF_TABLE_OF_CONTENT=$(($FIRST_LINE_OF_TABLE_OF_CONTENT_SECOND+1))

#boucle mettre les numéro de ligne dans la table des matières
m=0
		until [ ! $m -lt $TOTAL_ELEMENT_ARRAY_LINE_NUMBER_OF_COMMENTED_SECTION ]
	do
	gsed -i "$((${m}+${ADD_ONE_TO_FIRST_LINE_OF_TABLE_OF_CONTENT}))s/.*/\/\/Ligne : ${LINE_NUMBER_OF_COMMENTED_SECOND_SECTION[$m]}..........&/" $FILE

m=`expr $m + 1`
done
echo "---------------------------"
echo "Compiled table of content"
echo "---------------------------"
