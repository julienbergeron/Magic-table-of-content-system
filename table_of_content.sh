#!/bin/bash
################################################################################
#Configuration
################################################################################

#Path of text code file which contain the table of content
FILE="/Users/julien/scripts/magic-table-of-content-system/example/normalize.scss"
#head of Table of content
HEAD_TABLE_OF_CONTENT="//-----Table of content-----//"
#footer of Table of content
FOOTER_TABLE_OF_CONTENT="//--@Table of content@--//"
#marker at the begining of the comment line indicating items for table of content
TABLE_SECTION_MARKER="//@"
#comment special character
COMMENT_SPECIAL_CHARACTER="@"
#COMMENT_SPECIAL_CHARACTER="@"

#End configuration
################################################################################

#escape the slash of configuration variables for gsed using ; as a separetor
TABLE_SECTION_MARKER=$(echo $TABLE_SECTION_MARKER | gsed -e "s;/;\\\/;g")
HEAD_TABLE_OF_CONTENT=$(echo $HEAD_TABLE_OF_CONTENT | gsed -e "s;/;\\\/;g")
FOOTER_TABLE_OF_CONTENT=$(echo $FOOTER_TABLE_OF_CONTENT | gsed -e "s;/;\\\/;g")



echo "---------------------------"
FIRST_LINE_OF_TABLE_OF_CONTENT=$(gsed -n "/$HEAD_TABLE_OF_CONTENT/=" $FILE)
LAST_LINE_OF_TABLE_OF_CONTENT=$(gsed -n "/$FOOTER_TABLE_OF_CONTENT/=" $FILE)
echo $LAST_LINE_OF_TABLE_OF_CONTENT
FIRST_LINE_TO_DELETE=$(($FIRST_LINE_OF_TABLE_OF_CONTENT+1))
echo $FIRST_LINE_TO_DELETE
LAST_LINE_TO_DELETE=$(($LAST_LINE_OF_TABLE_OF_CONTENT-1))
echo $LAST_LINE_TO_DELETE 
gsed -i "${FIRST_LINE_TO_DELETE},${LAST_LINE_TO_DELETE}d" $FILE


#Firt get the title of the sections
LINE_NUMBER_OF_COMMENTED_SECTION=()
LINE_NUMBER_OF_COMMENTED_SECTION+=($(gsed -n "/$TABLE_SECTION_MARKER/=" "$FILE"))
TOTAL_ELEMENT_ARRAY_LINE_NUMBER_OF_COMMENTED_SECTION="${#LINE_NUMBER_OF_COMMENTED_SECTION[@]}"

LAST_LINE_OF_TABLE_OF_CONTENT=$(gsed -n "/$FOOTER_TABLE_OF_CONTENT/=" $FILE)
FIRST_LINE_OF_TABLE_OF_CONTENT=$(gsed -n "/$HEAD_TABLE_OF_CONTENT/=" $FILE)

#sections titles afectation in a list
j=0
	until [ ! $j -lt $TOTAL_ELEMENT_ARRAY_LINE_NUMBER_OF_COMMENTED_SECTION ]
	do

	SECTION_TITLE_WITH_ARROBAS[$j]=$(gsed -n "${LINE_NUMBER_OF_COMMENTED_SECTION[$j]} p" "$FILE")
	SECTION_TITLE_WITHOUT_ARROBAS[$j]=$(echo "${SECTION_TITLE_WITH_ARROBAS[$j]}" | gsed -e "s/$COMMENT_SPECIAL_CHARACTER//g")

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
LINE_NUMBER_OF_COMMENTED_SECOND_SECTION+=($(gsed -n "/$TABLE_SECTION_MARKER/=" "$FILE"))
FIRST_LINE_OF_TABLE_OF_CONTENT_SECOND=$(gsed -n "/$HEAD_TABLE_OF_CONTENT/=" $FILE)
ADD_ONE_TO_FIRST_LINE_OF_TABLE_OF_CONTENT=$(($FIRST_LINE_OF_TABLE_OF_CONTENT_SECOND+1))

#add line numbre to the table of content
m=0
		until [ ! $m -lt $TOTAL_ELEMENT_ARRAY_LINE_NUMBER_OF_COMMENTED_SECTION ]
	do
	#add line number in the beginning of items from table of content a the dots seperator
	gsed -i "$((${m}+${ADD_ONE_TO_FIRST_LINE_OF_TABLE_OF_CONTENT}))s/.*/\/\/Ligne : ${LINE_NUMBER_OF_COMMENTED_SECOND_SECTION[$m]}..........&/" $FILE

m=`expr $m + 1`
done
echo "---------------------------"
echo "Compiled table of content"
echo "---------------------------"
