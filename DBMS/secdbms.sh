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
	fi;;
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
    read -p "Please enter your Table Name: " tableName

    if [ -f "${tableName}_metadata" ]; then
        echo "Error: A table with the same name already exists."
        exit 1
    fi

    local columns
    read -p "Please enter the number of columns: " columns
    local set_primary_key=0
    local myColumns=()

    for ((i=0; i<columns; i++)); do 
        local column_name
        read -p "Please enter name of column $i: " column_name
            
        local primary_key_response
        if [ "$set_primary_key" -eq 0 ]; then 
            read -p "Do you want to make this column your primary key? [Y/N] " primary_key_response
            if [[ "$primary_key_response" =~ ^[Yy]$ ]]; then
                set_primary_key=1
            fi
        fi

        local column_datatype
        read -p "Enter data type of column $column_name [integer/string]: " column_datatype

        myColumns+=("$column_name:$set_primary_key:$column_datatype")
    done

    echo "Table name: $tableName" > "${tableName}_metadata"
    for column_info in "${myColumns[@]}"; do
        echo "$column_info" >> "${tableName}_metadata"
    done

    touch "${tableName}_data"
    echo "Table '$tableName' created successfully."
}


insertInTable() {
    local table_name
    read -p "Enter your table name: " table_name
    local metadata_file="${table_name}_metadata"
    local data_file="${table_name}_data"

    if [ ! -f "$metadata_file" ]; then
        echo "Error: Table '$table_name' does not exist."
        return 1
    fi

    local columns=()
    local skip=true
    while IFS=':' read -r column_name is_primary_key column_datatype; do
        if [ "$skip" = true ]; then
            skip=false
            continue 
        fi
        columns+=("$column_name:$is_primary_key:$column_datatype")
    done < "$metadata_file"

    local data=()
    for column_info in "${columns[@]}"; do
        IFS=':' read -r column_name is_primary_key column_datatype <<< "$column_info"
        read -p "Enter data for column $column_name: " column_value
	echo pk = $is_primary_key
	if [ "$is_primary_key" -eq 1 ]; then
            
              if isPrimaryKeyValueUnique "$data_file" "$column_value"; then
                echo "Error: Data for primary key '$column_name' must be unique."
                return 1
            fi 
           
        fi


        if [ "$column_datatype" = "integer" ] && ! [[ "$column_value" =~ ^[0-9]+$ ]]; then
            echo "Error: Invalid data type for column $column_name. Expected integer."
            return 1
        elif [ "$column_datatype" = "string" ] && [[ "$column_value" =~ ^[0-9]+$ ]]; then
            echo "Error: Invalid data type for column $column_name. Expected string."
            return 1
        fi

        data+=("$column_value")
    done

    echo "${data[*]}" >> "$data_file"
    echo "Data inserted successfully into table '$table_name'."
}


isPrimaryKeyValueUnique() {
    local data_file="$1"
    local column_value="$2"

    while IFS= read -r line; do
        # Check if primary key value already exists in the data file
        primary_key_value=$(echo "$line" | cut -d':' -f1)
        if [ "$primary_key_value" = "$column_value" ]; then
            return 1  # Not unique
        fi
    done < "$data_file"

    return 0
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
