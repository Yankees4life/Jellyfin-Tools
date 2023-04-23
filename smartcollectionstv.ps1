# Jellyfin server settings
$jellyfin_url = 'http://localhost:8096'
$jellyfin_api_key = 'ff1d4ab8714649d58612dc62296c799a'

# Set up the smart collection criteria
$collection_name = 'New Releases Shows 2023'
$collection_year = '2023'

# Build the search query
$query = "$jellyfin_url/Items?SortBy=DateCreated&SortOrder=Descending&IncludeItemTypes=Series&Recursive=true&Fields=BasicSyncInfo,PrimaryImageAspectRatio,SortName,Overview&Years=$collection_year&api_key=$jellyfin_api_key"

# Search for series based on the smart collection criteria
$results = Invoke-RestMethod -Method Get -Uri $query

# Create the new collection in Jellyfin
if ($results.TotalRecordCount -gt 0) {
    $collection_items = $results.Items.Id -join ","
    $create_collection_query = "$jellyfin_url/Collections?Name=$collection_name&Ids=$collection_items&api_key=$jellyfin_api_key"
    $response = Invoke-RestMethod -Method Post -Uri $create_collection_query
    if ($response.StatusCode -eq 200) {
        Write-Host "Successfully created collection '$collection_name' with $($results.TotalRecordCount) items."
    } else {
        Write-Host "Failed to create collection."
    }
} else {
    Write-Host "No items found that match the smart collection criteria."
}
