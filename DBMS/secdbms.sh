#!/bin/bash

createDB() {
local flag=0
while true; do
    local new_db_name
    read -p "Please enter your DB Name: " new_db_name
    if [ -d "$new_db_name" ]
	then
		 echo "Database already exists."
		 flag=1
	elif [ -z $new_db_name ]
	then 
		echo " can't create a database with no name."
	elif [[ ! "$new_db_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    		echo "Invalid database name."
		echo " The name must start with a letter and can contain only letters, numbers, and underscores."


	else
	mkdir "$new_db_name"
	if [ $? -eq 0 ]; then
		echo "Database '$new_db_name' created Successfully"
		echo "Do you want to connect to this database ?[Y/N]"
        	read response

        	case $response in
        	[Yy]*)
        	cd "$PWD/$new_db_name";;

        	[Nn]*)
        	return 0;;
        	*)
        	echo "Invalid response"
        	esac
		break;
	 else
                echo "Failed to create database '$new_db_name'."
         fi
   fi
done
}

listDB() {
   ls -F |grep /
}

deleteDB() {
    read -p "Please enter DB Name you want to delete: " del_dbname

    if [ ! -d "$del_dbname" ]; then
        echo "Database '$del_dbname' not found."
        return;
	else
	echo "Are you sure you want to delete "$del_dbname"? [Y/N]"
	read resp

        case $resp in
        [Yy]*)
        rm -r "$del_dbname"
	if [ $? -eq 0 ]; then
                    echo "Database '$del_dbname' deleted successfully."
                else
                    echo "Failed to delete database '$del_dbname'. Please check permissions or try again later."
	fi

        [Nn]*)
        return;;
        *)
        echo "Invalid response";;
        esac
fi
}

connectDB() {
    read -p "Please enter DB Name to connect: " dbname
    local folderArray
    local flag=0

    if [ -d "$dbname" ]; then 
        flag=1
        cd "$dbname"
        echo "$dbname is connected successfully."
        openConnection
        break
    else
        echo "$dbname not found."
    fi
}

openConnection() {
    select name in ViewTable ListAllTable CreateTable InsertInTable UpdateTable DeleteTable Back; do
        case $REPLY in
            1) viewTable ;;
            2) listAllTable ;;
            3) createTable ;;
            4) insertInTable ;;
            5) updateTable ;;
            6) deleteTable ;;
            7) backToMain; break ;;
            *) echo "Invalid input" ;;
        esac
    done
}

viewTable() {
    echo "done"
}

listAllTable() {
    local folderArray
    readarray -t folderArray <<< "$(ls)"

    for file in "${folderArray[@]}"; do
        if [ -f "$file" ]; then
            echo "$file"
        fi
    done
}

createTable() {
    local tableName
    read -p "Please enter your Table Name: " tableName

    if [ -e "$tableName.table" ]; then
        echo "Error: A table with the same name already exists."
        return 1
    fi

    local columns
    read -p "Please enter your columns : " columns

    local myColumns=()
    read -r -a myColumns <<< "$columns"

    if [ ${#myColumns[@]} -eq 0 ]; then
        echo "Error: No columns provided."
        return 1
    fi

    touch "$tableName.table" || {
        echo "Error: Failed to create the table file."
        return 1
    }
    local IFS=:
    echo "${myColumns[*]}" >> "$tableName.table" 

    echo "Table '$tableName' created successfully with columns: ${myColumns[*]}"
}

insertInTable() {
    echo "done"
}

updateTable() {
    echo "done"
}

deleteTable() {
    read -p "Please enter Table Name to delete: " tbName

    if [ -e "$tbName".table ]; then 
        rm -r "$tbName"
        echo "$tbName is deleted successfully."
    else
        echo "$tbName not found."
    fi

}

backToMain() {
    cd ..
    echo "back to main menu"
}

if [ -d "Databases" ];
then
	cd "Databases";
else
	mkdir "Databases";
	cd "Databases"; 
fi


select name in CreateDB ListDB ConnectDB DeleteDB Exit; do
    case $REPLY in
        1) createDB ;;
        2) listDB ;;
        3) connectDB ;;
        4) deleteDB ;;
        5) break ;;
        *) echo "Invalid input" ;;
    esac
done
