param(
    [string[]]
    $Tags = 'latest'
)
$tagParams = @()
foreach($tag in $tags)
{
    $tag = $tag.ToLowerInvariant()
    $tagParams += "travisez13/microsoft.windowsservercore.git:$tag"
}
docker build -t travisez13/microsoft.windowsservercore.git $PSScriptRoot