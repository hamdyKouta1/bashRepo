#!/bin/bash

createDB() {
    local dbname
    read -p "Please enter your DB Name: " dbname
    local folderArray
    readarray -t folderArray <<< "$(ls)"
    local i=0
    local flag=0

    for file in "${folderArray[@]}"; do
        if [ "$dbname" = "$file" ]; then 
            echo "This DB already exists."
            flag=1
            break
        fi
        ((i++))
    done

    if [ $flag -eq 0 ]; then 
        echo "$dbname DB created successfully."
        mkdir "$dbname"
        flag=0
    fi
}

listDB() {
    local folderArray
    readarray -t folderArray <<< "$(ls)"

    for file in "${folderArray[@]}"; do
        if [ -d "$file" ]; then
            echo "$file"
        fi
    done
}

deleteDB() {
    read -p "Please enter DB Name to delete: " dbname
    local folderArray
    readarray -t folderArray <<< "$(ls)"
    local flag=0

    for file in "${folderArray[@]}"; do
        if [ "$dbname" = "$file" ]; then 
            flag=1
            rm -r "$dbname"
            echo "$dbname is deleted successfully."
            break
        fi
    done

    if [ $flag -eq 0 ]; then
        echo "$dbname not found."
    fi
}

connectDB() {
    read -p "Please enter DB Name to connect: " dbname
    local folderArray
    readarray -t folderArray <<< "$(ls)"
    local flag=0

    for file in "${folderArray[@]}"; do
        if [ "$dbname" = "$file" ]; then 
            flag=1
            cd "$dbname"
            echo "$dbname is connected successfully."
            openConnection
            break
        fi
    done

    if [ $flag -eq 0 ]; then
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

    # Create the table file
    touch "$tableName.table" || {
        echo "Error: Failed to create the table file."
        return 1
    }
    local IFS=:
        echo "${myColumns[*]}" >> "$tableName.table" 


    echo "Table '$tableName' created successfully with columns: ${myColumns[*]}"
}


createTablje() {

    local tableName
    read -p "Please enter your Table Name: " tableName
    local folderArray
    readarray -t folderArray <<< "$(ls)"
    local i=0
    local flag=0

    for file in "${folderArray[@]}"; do
        if [ "$tableName".table = "$file" ]; then 
            echo "can not create more than table with same name"
            flag=1
            break
        fi
        ((i++))
    done

    if [ $flag -eq 0 ]; then 
        echo "$tableName Table created successfully."
        read -p "Please enter your columns: " columns
        local myColumns=()
        echo "$columns" | readarray -t myColumns

        touch "$tableName".table

         for col in "${myColumns[@]}"; do
            echo "$col:" 

          done
        echo "( $myColumns ) inserted to Table : $tableName.table"
        
        flag=0
    fi
}

insertInTable() {
    echo "done"
}

updateTable() {
    echo "done"
}

deleteTable() {
    read -p "Please enter Table Name to delete: " tbName
    local filesArray
    readarray -t filesArray <<< "$(ls)"
    local flag=0

    for file in "${filesArray[@]}"; do
        if [ "$tbName" = "$file" ]; then 
            flag=1
            rm -r "$tbName"
            echo "$tbName is deleted successfully."
            break
        fi
    done

    if [ $flag -eq 0 ]; then
        echo "$tbName not found."
    fi
}

backToMain() {
    cd ..
    echo "back to main menu"
}

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
