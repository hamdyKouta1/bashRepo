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

    if [ ! -f "$metadata_file" ]; then
        echo "Error: Table '$table_name' does not exist."
        return 1
    fi

    local columns=()

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
   
    echo "Data inserted successfully into table '$table_name'."
}




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
     while true; do    
     read -p "Enter value of $get_pk to update : " target_record
        if [ ${columns_types_arr[$pk_nr]}  = "integer" ] && [[ "$target_record" =~ ^[0-9]+$ ]]; then
            break    
        elif [ ${columns_types_arr[$pk_nr]}  = "string" ] && [[ "$target_record" =~ ^[0-9]+$ ]]; then
            break
        else
        echo "not compatible type"
        fi
     done


      while true; do    
     read -p "Enter column name to update : " target_field
         if [[ " ${columns_names_arr[@]} " =~ " $target_field " ]]; then
             break
        else
            echo "Target field not found. Please try again."
        fi
     done

    let c=1
    for val in "${columns_names_arr[@]}"; do
    if [[ $val == $target_field ]]; then
        found=1
        break
    fi
    ((c++))
    done

    

    local updated_value

while true; do    
    read -p "Enter  new value : " updated_value
        if [ ${columns_types_arr[$((c-1))]}  = "integer" ] && [[ "$target_record" =~ ^[0-9]+$ ]]; then
            break    
        elif [ ${columns_types_arr[$((c-1))]}  = "string" ] && [[ "$target_record" =~ ^[0-9]+$ ]]; then
            break
        else
        echo "not compatible type"
        fi
     done
    field_name="$pk_nr"
    value_to_check="$target_record"


    res=$(awk -F ':' -v field="$field_name" -v val="$value_to_check" '
        BEGIN { OFS=":"; IFS=":" }
        $field == val { found=1 }
        END { print found }
    ' "${table_name}_data.table")

        if [ -n "$res" ] && [ "$res" -eq 1 ]; then

            echo "found and updated"

            temp_file="tmp%tmp"
            touch "$temp_file"

            awk -F ':' -v field="$field_name" -v val="$value_to_check" -v updatec="$c" -v updated_value="$updated_value" '
                    BEGIN { OFS=":";IFS=":" }
                    $field == val {  found=1;   $updatec=updated_value; }   
                    1
                    
                    ' "${table_name}_data.table" > "${temp_file}"

       
        
            mv "$temp_file" "${table_name}_data.table"

        else
            echo "target record can not be found"
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
