Generate self signed CA token with ip address

``` pwsh
New-SelfSignedCertificate -CertStoreLocation Cert:\CurrentUser\My -TextExtension @('2.5.29.19={text}CA=true','2.5.29.17={text}DNS=domainName&IPAddress=10.10.0.12') -KeyUsage CertSign,CrlSign,DigitalSignature -FriendlyName domainName
```