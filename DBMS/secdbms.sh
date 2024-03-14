#!/bin/bash
 db_c="DBContainer"

createDB() {
local flag=0
echo "Creating New DataBase"
echo "Type 'Cancel' to Cancel The Process" 
pattern="^(cancel|Cancel|CANCEL)$"

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

	elif [[ "$new_db_name" =~ $pattern ]]; then
    	echo "canceled"
        break

	else
	mkdir "$new_db_name"
	if [ $? -eq 0 ]; then
		echo "Database '$new_db_name' created Successfully"
		echo "Do you want to connect to this database ?[Y/N]"
        	read response

        	case $response in
        	[Yy]*)
        	cd "$PWD/$new_db_name"
            openConnection
            ;;

        	[Nn]*)
	    	echo "Database '$new_db_name' created Successfully Type 2 to list your DBs"
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
        echo "Connected To DB: $dbname ."
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
    ls -F |grep .table
}


createTable() {
    read -p "Please enter your Table Name: " tableName

    if [ -f "$tableName" ]; then
        echo "Error: A table with the same name already exists."
        return 1
    fi

    local columns
    read -p "Please enter the number of columns : " columns

    local myColumns=()
    local set_primary_key=0
    local flag_pk=0


    for((i=0; i<columns ; i++));
    do 
        
       local column_name
       read -p "Please enter name of column $((i+1)) : " column_name
       
       local primary_key_response

       if [ "$flag_pk" -eq 0 ]; then
            if [ "$set_primary_key" -eq 0 ];
            then 
                    read -p "Do you want to make this column your primary key ?[Y/N]" primary_key_response
                    if [[ "$primary_key_response" =~ ^[Yy]$ ]]; then

                        set_primary_key=1
                        flag_pk=1
                    fi
                fi
        fi
        local column_datatype
        read -p "Enter data type of column $column_name [integer/string] :" column_datatype
       
        mycolumns[$i]="$column_name:$set_primary_key:$column_datatype"
        set_primary_key=0
   done
   
   echo "Table name: $tableName" >> "${tableName}_metadata"

   for column_info in "${mycolumns[@]}"; do
    echo "$column_info"
        echo "$column_info" >> "${tableName}_metadata"
   done

   touch "${tableName}_data.table"
   echo "${mycolumns[@]}"
   echo "Table '$tableName' created successfully."
   
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
exitDBMS(){
    cd ..
    echo "disconnected"
}

if [ -d "$db_c" ]; then
    cd "$db_c"
else
    mkdir "$db_c"
    cd "$db_c"
fi


select name in CreateDB ListDB ConnectDB DeleteDB Exit; do
    case $REPLY in
        1) createDB ;;
        2) listDB ;;
        3) connectDB ;;
        4) deleteDB ;;
        5) exitDBMS; break ;;
        *) echo "Invalid input" ;;
    esac
done
