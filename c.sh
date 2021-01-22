#!/bin/bash

<<<<<<< HEAD
printf("#include <stdio.h> \

int main(void) {

        int n;

        do {
                printf("Inserisci qualcosa\n");
                scanf("%n", &n);
        } while (n);

        return = 0;
}
=======
FILE=$(zenity --file-selection --title="Select file you want to compile and run")

zenity --question --text="Are you using math library?"

rc=$?

if [ "${rc}" == "1" ]; then

	gcc $FILE -o temp

else
	
	gcc $FILE -o temp -lm

fi 

sleep 3

${PWD}/temp

echo -e "\n\n"
read -p "Press any key to continue... " -n1 -s
rm ${PWD}/temp
echo -e "\n\n"

exit 0
>>>>>>> 77e5dc623e2e06d029def50f148f9bd2f50528fd
