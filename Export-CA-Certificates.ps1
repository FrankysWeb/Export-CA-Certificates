$CAName = "Name der CA"
$TemplateName = "Name der Vorlage"
$ExportDir = "C:\ExportCerts"

$ca = Get-CertificationAuthority -Name $CAName
$allCerts = Get-IssuedRequest -CertificationAuthority $ca -property RawCertificate
 
$ValidCerts = $allcerts | Where-Object {$_.NotAfter -gt (get-date)}

$SANCerts = $ValidCerts | Where-Object { $_.CertificateTemplateOid.FriendlyName -match "$TemplateName"}
 
$pattern = '[^a-zA-Z]'
foreach ($SANCert in $SANCerts) {
 $CommonName = $SANCert.CommonName
 $FileName = $CommonName -replace $pattern
 $filepath = $ExportDir + "\" + "$FileName" + ".cer"
 $SANCert.RawCertificate |  set-content $filepath
}