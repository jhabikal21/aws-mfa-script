# aws-mfa-script
By default, aws cli won't work with existing Access/Secret Key. Hence, after enabling MFA, we need to run below script to get new  Access/Secret Key &amp; Secret Token which expires every --duration 129600s. Post running this script, we can run as Usual cli commands just by passing  --profile (existingprofile)-mfa.
