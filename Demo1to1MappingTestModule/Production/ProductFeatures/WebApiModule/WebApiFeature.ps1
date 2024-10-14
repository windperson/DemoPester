function Get-HttpGetResponse {
    param (
        [string] $apiUrl,
        [hashtable] $headers,
        [string] $httpVersion = "1.1"
    )

    $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -Method Get -HttpVersion $httpVersion
    return $response
}