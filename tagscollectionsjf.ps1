# Set Jellyfin server information
$server = "http://localhost:8096"
$apiKey = "ff1d4ab8714649d58612dc62296c799a"

# Set library ID
$libraryId = "0c41907140d802bb58430fed7e2cd79e"

# Set tag names and corresponding collection names
$tagsToCollections = @{
    "Summer 2022" = "Anime - Summer 2022"
    "Fall 2022" = "Anime - Fall 2022"
    "Winter 2022" = "Anime - Winter 2022"
}

# Loop through each tag and create a collection for it
foreach ($tag in $tagsToCollections.Keys) {
    # Get media items with tag
    $url = "$server/Items?api_key=$apiKey&Recursive=true&IncludeItemTypes=Movie,Series,Episode&MediaTypes=Video&Fields=Tags&Tags=$tag&ParentId=$libraryId"
    $json = Invoke-RestMethod -Uri $url

    # Get item IDs with tag
    $itemIds = $json.Items.Id | ForEach-Object { $_.ToString() } -Join ","

    # Create collection
    $collectionName = $tagsToCollections[$tag]
    $collectionUrl = "$server/Collections?api_key=$apiKey"
    $collectionJson = @{
        "Name" = $collectionName
        "ItemType" = "2"
        "Ids" = $itemIds
    } | ConvertTo-Json
    Invoke-RestMethod -Method Post -Uri $collectionUrl -Body $collectionJson
}
