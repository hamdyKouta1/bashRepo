#!/bin/bash
<<<<<<< HEAD

createDB() {
local flag=0
=======
 db_c="DBContainer"

createDB() {
local flag=0
echo "Creating New DataBase"
echo "Type 'Cancel' to Cancel The Process" 
pattern="^(cancel|Cancel|CANCEL)$"

>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268
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

<<<<<<< HEAD
=======
	elif [[ "$new_db_name" =~ $pattern ]]; then
    	echo "canceled"
        break
>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268

	else
	mkdir "$new_db_name"
	if [ $? -eq 0 ]; then
		echo "Database '$new_db_name' created Successfully"
		echo "Do you want to connect to this database ?[Y/N]"
        	read response

        	case $response in
        	[Yy]*)
<<<<<<< HEAD
        	cd "$PWD/$new_db_name";;

        	[Nn]*)
=======
        	cd "$PWD/$new_db_name"
            openConnection
            ;;

        	[Nn]*)
	    	echo "Database '$new_db_name' created Successfully Type 2 to list your DBs"
>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268
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
<<<<<<< HEAD
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

=======
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
>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268
fi
}

connectDB() {
    read -p "Please enter DB Name to connect: " dbname
    local folderArray
    local flag=0

    if [ -d "$dbname" ]; then 
        flag=1
        cd "$dbname"
<<<<<<< HEAD
        echo "$dbname is connected successfully."
=======
        echo "Connected To DB: $dbname ."
>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268
        openConnection
        break
    else
        echo "$dbname not found."
    fi
}

openConnection() {
<<<<<<< HEAD
=======
    
>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268
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
<<<<<<< HEAD
=======
    
>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268
    done
}

viewTable() {
<<<<<<< HEAD
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
=======
    local tbName
    read -p "Please enter name of table : " tbName
    if [ -e "${tbName}_data.table" ]; then
    cat "${tbName}_metadata"
    else
    echo "not found"
    fi
       
}

listAllTable() {
    ls -F |grep .table
}


createTable() {
    read -p "Please enter your Table Name: " tableName

    if [ -e "${tableName}_data.table" ]; then
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

   unset mycolumns
   
}




insertInTable() {

    local table_name
    read -p "Enter your table name: " table_name

    local metadata_file="${table_name}_metadata"

    local data_file="${table_name}_data.table"
>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268

    if [ ! -f "$metadata_file" ]; then
        echo "Error: Table '$table_name' does not exist."
        return 1
    fi

    local columns=()
<<<<<<< HEAD
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
=======

    local skip=true

    get_pk=$(awk -F ':' '$2=="1"{print $1}' "${table_name}_metadata")
    get_pk_nr=$(awk -F ':' '$2=="1"{print NR}' "${table_name}_metadata")
    pk_nr=$((get_pk_nr-1))
    get_all_columns_name=$(awk -F ':' 'NR!=1 {print $1}' "${table_name}_metadata")
    get_all_columns_type=$(awk -F ':' 'NR!=1 {print $3}' "${table_name}_metadata")

    num_records=$(awk 'END {print NR}' "${table_name}_metadata")

    echo "your pk is : $get_pk which is field no. $pk_nr"

    readarray -t columns_names_arr <<< "$get_all_columns_name"
    readarray -t columns_types_arr <<< "$get_all_columns_type"

    for c_name in "${columns_names_arr[@]}"; do
        echo "Column: $c_name"
    done

    myData=()



    for((i=0; i<((num_records-1)) ; i++));
    do
    local flag=0
     local column_values=""
     read -p "Enter data for column ${columns_names_arr[$i]} : " column_value

      if [ $((i+1)) -eq $pk_nr ]; then
    


        field_name="$pk_nr"
        value_to_check="$column_value"

        res=$(awk -F ':' -v field="$field_name" -v val="$value_to_check" '$field == val {found=1; exit} END{print found}' "${table_name}_data.table")

        if [ -n "$res" ] && [ "$res" -eq 1 ]; then
            echo "THIS PK IS RESOLVED"
            flag=1
        fi
     fi


     if [ ${columns_types_arr[$i]}  = "integer" ] && ! [[ "$column_value" =~ ^[0-9]+$ ]]; then
            echo "Error: Invalid data type for column $column_name. Expected integer."
            return 1
        elif [ ${columns_types_arr[$i]}  = "string" ] && [[ "$column_value" =~ ^[0-9]+$ ]]; then
            echo "Error: Invalid data type for column $column_name. Expected string."
            return 1
     fi

        myData[$i]=$column_value  

        if [ "$flag" -eq 1 ]; then
        ((i--))
        fi

    done

    echo "${myData[@]}"
    local IFS=:
    echo "${myData[*]}" >> "${table_name}_data.table"



unset  columns_names_arr
unset  columns_types_arr
   
>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268
    echo "Data inserted successfully into table '$table_name'."
}


<<<<<<< HEAD
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
=======


updateTable() {
   
    local table_name
    read -p "Enter your table name: " table_name

    local metadata_file="${table_name}_metadata"

    local data_file="${table_name}_data.table"

    if [ ! -f "$metadata_file" ]; then
        echo "Error: Table '$table_name' does not exist."
        return 1
    fi

    local columns=()

    get_pk=$(awk -F ':' '$2=="1"{print $1}' "${table_name}_metadata")
    get_pk_nr=$(awk -F ':' '$2=="1"{print NR}' "${table_name}_metadata")
    pk_nr=$((get_pk_nr-1))
    get_all_columns_name=$(awk -F ':' 'NR!=1 {print $1}' "${table_name}_metadata")
    get_all_columns_type=$(awk -F ':' 'NR!=1 {print $3}' "${table_name}_metadata")

    num_records=$(awk 'END {print NR}' "${table_name}_metadata")

    echo "your pk is : $get_pk which is field no. $pk_nr"

    readarray -t columns_names_arr <<< "$get_all_columns_name"
    readarray -t columns_types_arr <<< "$get_all_columns_type"

    echo "${columns_names_arr[@]}"
  

    myData=()

     local target_record
     local target_field

     read -p "Enter value of $get_pk to update : " target_record

     read -p "Enter column name to update : " target_field

    let c=1
    for val in "${columns_names_arr[@]}"; do
    if [[ $val == $target_field ]]; then
        found=1
        break
    fi
    ((c++))
    done
    temp_file="tmp%tmp"
    touch "$temp_file"

    local updated_value

    read -p "Enter  new value : " updated_value

    field_name="$pk_nr"
    value_to_check="$target_record"

awk -F ':' -v field="$field_name" -v val="$value_to_check" -v updatec="$c" -v updated_value="$updated_value" '
    BEGIN { OFS=":" }
    $field == val {  found=1;   $updatec=updated_value; }   
    1
  
' "${table_name}_data.table" > "${temp_file}"

        #if [ -n "$res" ] && [ "$res" -eq 1 ]; then
         #   echo "updated"
          #  flag=1
        #fi
        mv "$temp_file" "${table_name}_data.table"


    echo " ${columns_names_arr[$((c-1))]}"


>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268

}

backToMain() {
    cd ..
    echo "back to main menu"
}
<<<<<<< HEAD

if [ -d "Databases" ];
then
	cd "Databases";
else
	mkdir "Databases";
	cd "Databases"; 
=======
exitDBMS(){
    cd ..
    echo "disconnected"
}

if [ -d "$db_c" ]; then
    cd "$db_c"
else
    mkdir "$db_c"
    cd "$db_c"
>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268
fi


select name in CreateDB ListDB ConnectDB DeleteDB Exit; do
    case $REPLY in
        1) createDB ;;
        2) listDB ;;
        3) connectDB ;;
        4) deleteDB ;;
<<<<<<< HEAD
        5) break ;;
=======
        5) exitDBMS; break ;;
>>>>>>> a3a376a68298d07c8d689e5158f30f3dff0ba268
        *) echo "Invalid input" ;;
    esac
done
