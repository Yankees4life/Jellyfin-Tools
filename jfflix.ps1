# Set Jellyfin server URL and API key
$jellyfinUrl = "http://localhost:8096"
$jellyfinApiKey = "ff1d4ab8714649d58612dc62296c799a"

# Set The Movie DB API key
$tmdbApiKey = "9de77d3de6c2c584323cf836361e8212"

# Get all movies and shows from Jellyfin library
$allItemsUrl = "$jellyfinUrl/Items?api_key=$jellyfinApiKey&Recursive=true&IncludeItemTypes=Movie,Series"

$allItemsResponse = Invoke-RestMethod -Method Get -Uri $allItemsUrl

# Loop through all items and get their titles
foreach ($item in $allItemsResponse.Items) {
    $title = $item.Name
    
    # Check if item is a movie or a show
    if ($item.Type -eq "Movie") {
        # Search The Movie DB for the movie
        $searchUrl = "https://api.themoviedb.org/3/search/movie?api_key=$tmdbApiKey&query=$title"
        
        $searchResponse = Invoke-RestMethod -Method Get -Uri $searchUrl
        
        # Check if any results were found
        if ($searchResponse.total_results -gt 0) {
            # Check if the movie is available on Netflix
            $movieId = $searchResponse.results[0].id
            $movieDetailsUrl = "https://api.themoviedb.org/3/movie/$movieId?api_key=$tmdbApiKey&append_to_response=watch/providers"
            
            $movieDetailsResponse = Invoke-RestMethod -Method Get -Uri $movieDetailsUrl
            
            if ($movieDetailsResponse["watch/providers"].results.netflix -ne $null) {
                Write-Host "Movie '$title' is available on Netflix"
            }
        }
    }
    elseif ($item.Type -eq "Series") {
        # Search The Movie DB for the show
        $searchUrl = "https://api.themoviedb.org/3/search/tv?api_key=$tmdbApiKey&query=$title"
        
        $searchResponse = Invoke-RestMethod -Method Get -Uri $searchUrl
        
        # Check if any results were found
        if ($searchResponse.total_results -gt 0) {
            # Check if the show is available on Netflix
            $showId = $searchResponse.results[0].id
            $showDetailsUrl = "https://api.themoviedb.org/3/tv/$showId?api_key=$tmdbApiKey&append_to_response=watch/providers"
            
            $showDetailsResponse = Invoke-RestMethod -Method Get -Uri $showDetailsUrl
            
            if ($showDetailsResponse["watch/providers"].results.netflix -ne $null) {
                Write-Host "Show '$title' is available on Netflix"
            }
        }
    }
}
