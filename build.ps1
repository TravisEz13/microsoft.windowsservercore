param(
    [string[]]
    $Tags = 'latest',
    [switch]
    $NoCache
)
$repoName = &"$psscriptroot\reponame.ps1"
$tagParams = @()
foreach($tag in $tags)
{
    $tag = $tag.ToLowerInvariant()
    $tagParams += '-t'
    $tagParams += "${repoName}:$tag"
}
if($NoCache)
{
    $tagParams += '--no-cache'
}
docker build $tagParams $PSScriptRoot