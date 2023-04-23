# Set variables
$jellyfinServerURL = "http://localhost:8096"
$jellyfinAPIKey = ""
$libraries = @{
    "" = "Trending Movies";
    "" = "Trending Movies 18+";
}
$minRating = 7
$minYear = 2022

# Loop through libraries and create collections
foreach ($libraryID in $libraries.Keys) {
    $collectionName = $libraries[$libraryID]
    Write-Host "Creating collection for library $($libraryID) with name $($collectionName)"

    # Get list of items in library
    $itemsURL = "$jellyfinServerURL/items?ParentId=$libraryId&IncludeItemTypes=Movie&api_key=$jellyfinAPIKey&Recursive=true"
    $itemsResponse = Invoke-RestMethod -Uri $itemsURL -Method Get
    $items = $itemsResponse.Items | Where-Object { $_.PremiereDate.Year -ge $minYear -and $_.CommunityRating -ge $minRating }

    # Create collection
    $itemIDs = $items.Id -join ","
    $collectionURL = "$jellyfinServerURL/Collections?Name=$($collectionName)&Ids=$($itemIDs)&api_key=$jellyfinAPIKey"
    $collectionResponse = Invoke-RestMethod -Uri $collectionURL -Method Post
}
