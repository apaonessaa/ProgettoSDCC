#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <server_address>"
    exit 1
fi

SERVER=$1
CATEGORY_ENDPOINT="http://$SERVER/api/categories"
FILE_TO_READ="$PWD/data/categories.json"

if [ ! -f "$FILE_TO_READ" ]; then
    echo "Error: File $FILE_TO_READ does not exist."
    exit 1
fi

# Iterate through categories using jq to output raw strings safely
jq -c '.[]' "$FILE_TO_READ" | while read -r category_obj; do
    
    # Extract parent category details
    CAT_NAME=$(echo "$category_obj" | jq -r '.name')
    CAT_DESCR=$(echo "$category_obj" | jq -r '.description')

    echo "Creating category: $CAT_NAME..."

    # Create Category using a heredoc to avoid manual JSON string escaping issues
    curl -s -X POST "$CATEGORY_ENDPOINT" \
        -H 'Content-Type: application/json' \
        -d "$(jq -n --arg name "$CAT_NAME" --arg desc "$CAT_DESCR" \
            '{name: $name, description: $desc, subcategories: []}')"
    
    echo -e "\n"
    sleep 1

    # Iterate through subcategories for this specific category
    echo "$category_obj" | jq -c '.sub[]?' | while read -r subcat_obj; do
        [ -z "$subcat_obj" ] && continue

        SUB_NAME=$(echo "$subcat_obj" | jq -r '.name')
        SUB_DESCR=$(echo "$subcat_obj" | jq -r '.description')

        echo "  -> Creating subcategory: $SUB_NAME"

        # Create Subcategory
        curl -s -X POST "$CATEGORY_ENDPOINT/$CAT_NAME/subcategories" \
            -H 'Content-Type: application/json' \
            -d "$(jq -n --arg name "$SUB_NAME" --arg desc "$SUB_DESCR" --arg cat "$CAT_NAME" \
                '{name: $name, description: $desc, category: $cat, articles: []}')"
        echo -e "\n"
    done
done