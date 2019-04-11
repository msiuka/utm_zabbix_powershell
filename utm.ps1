$web = Invoke-WebRequest -Uri http://127.0.0.1:8080
$content = $web.RawContent
if ($args[0] -eq "PKIID")
{
    $parsed = [Regex]::Matches($content,"<\/span>RSA (.+)<\/div><\/div>")
    write-output $parsed[0].Groups[1].Value
}
if ($args[0] -eq "VERSION")
{
    $parsed = [Regex]::Matches($content,'Версия ПО<\/div><div class="col-md-8 col-sm-8 col-lg-8">(.+)<\/div><\/div>')
    write-output $parsed[0].Groups[1].Value
}
if ($args[0] -eq "PKI")
{
    $parsed = [Regex]::Matches($content,"RSA.+Действителен с .+ по (.+) \+.+")
    $CurrentDate = Get-Date
    $date = Get-Date -Date $parsed[0].Groups[1].Value
    $unixtime = [math]::Round((New-TimeSpan -Start $CurrentDate -End $date).TotalDays)
    write-output $unixtime
}
if ($args[0] -eq "GOST")
{
    $parsed = [Regex]::Matches($content,"ГОСТ.+Действителен с .+ по (.+) \+.+")
    $CurrentDate = Get-Date
    $date = Get-Date -Date $parsed[0].Groups[1].Value
    $unixtime = [math]::Round((New-TimeSpan -Start $CurrentDate -End $date).TotalDays)
    write-output $unixtime
}
if ($args[0] -eq "LASTCHECK")
{
    $parsed = [Regex]::Matches($content,'Неотправленные чеки.+8\">(.+)<\/div><\/div>')
    $CurrentDate = Get-Date
    if ($parsed[0].Groups[1].Value -eq "Отсутствуют неотправленные чеки")
    {
        write-output 0
    }
    else
    {
       $date = Get-Date -Date $parsed[0].Groups[1].Value
       $unixtime = [math]::Round((New-TimeSpan -Start $date -End $CurrentDate).TotalHours)
       write-output $unixtime
    }
}