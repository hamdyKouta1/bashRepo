#!/bin/bash

createDB() {
    local dbname
    read -p "Please enter your DB Name: " dbname

    if [ -e "$dbname" ]; then 
        echo "This DB already exists."
        flag=1
    else
        echo "$dbname DB created successfully."
        mkdir "$dbname"
    fi
}

listDB() {
    local folderArray
    readarray -t folderArray <<< "$(ls)"

    for dir in "${folderArray[@]}"; do
        if [ -d "$dir" ]; then
            echo "$dir"
        fi
    done
}

deleteDB() {
    read -p "Please enter DB Name to delete: " dbname

    if [ -e "$dbname" ]; then 
        rm -r "$dbname"
        echo "$dbname is deleted successfully."
    else 
        echo "$dbname not found."
    fi
}

connectDB() {
    read -p "Please enter DB Name to connect: " dbname
    local folderArray
    local flag=0

    if [ -e "$dbname" ]; then 
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
