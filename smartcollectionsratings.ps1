# Jellyfin server settings
$jellyfin_url = 'http://localhost:8096'
$jellyfin_api_key = ''

# Set up the collection criteria
$collection_name = 'Highly Rated Movies'
$minimum_rating = 7

# Build the search query
$query = "$jellyfin_url/Items?Recursive=true&IncludeItemTypes=Movie&api_key=$jellyfin_api_key"

# Search for movies based on the collection criteria
$results = Invoke-RestMethod -Method Get -Uri $query

# Filter the results based on community rating
$filtered_results = $results.Items | Where-Object { $_.CommunityRating -ge $minimum_rating }

# Create the new collection in Jellyfin
if ($filtered_results.Count -gt 0) {
    $collection_items = $filtered_results.Id -join ","
    $create_collection_query = "$jellyfin_url/Collections?Name=$collection_name&Ids=$collection_items&api_key=$jellyfin_api_key"
    $response = Invoke-RestMethod -Method Post -Uri $create_collection_query
    if ($response.StatusCode -eq 200) {
        Write-Host "Successfully created collection '$collection_name' with $($filtered_results.Count) items."
    } else {
        Write-Host "Failed to create collection."
    }
} else {
    Write-Host "No items found that match the collection criteria."
}
