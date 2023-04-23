import requests
import json

# Jellyfin server settings
jellyfin_url = 'http://localhost:8096'
jellyfin_api_key = ''

# Set up the smart collection criteria
collection_name = 'New Releases'
collection_genre = 'action'
collection_year = '2022'

# Build the search query
query = f"{jellyfin_url}/{collection_type}/search?SortBy=DateCreated&SortOrder=Descending&IncludeItemTypes=Movie&Recursive=true&Fields=BasicSyncInfo,PrimaryImageAspectRatio,SortName,Overview&Genres={collection_genre}&Years={collection_year}&api_key={jellyfin_api_key}"

# Search for movies based on the smart collection criteria
response = requests.get(query)
results = json.loads(response.text)

# Create the new collection in Jellyfin
if results['TotalRecordCount'] > 0:
    collection_items = ','.join([str(i['Id']) for i in results['Items']])
    create_collection_query = f"{jellyfin_url}/emby/Collections?Name={collection_name}&Ids={collection_items}&api_key={jellyfin_api_key}"
    response = requests.post(create_collection_query)
    if response.status_code == 200:
        print(f"Successfully created collection '{collection_name}' with {results['TotalRecordCount']} items.")
    else:
        print("Failed to create collection.")
else:
    print("No items found that match the smart collection criteria.")
