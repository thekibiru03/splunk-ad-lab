Import-Module ADDSDeployment
Install-ADDSForest `
  -DomainName "{{ ad_domain_name }}" `
  -DomainNetbiosName "{{ ad_domain_name.split('.')[0] | upper }}" `
  -DomainMode Win2012R2 `
  -ForestMode Win2012R2 `
  -InstallDns `
  -SafeModeAdministratorPassword (ConvertTo-SecureString "{{ ad_dsrm_password }}" -AsPlainText -Force) `
  -NoRebootOnCompletion:$true # Changed from -Force