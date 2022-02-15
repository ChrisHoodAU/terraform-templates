# Provide the DKIM records in a human readable format
output "dkim_records" {
  value = [for domain in aws_ses_domain_dkim.workday : "${formatlist("%s._domainkey.%s CNAME %s.dkim.amazonses.com", domain.dkim_tokens, domain.id, domain.dkim_tokens)}"]
}

# Provide the Mail-From records in a human readable format
output "mailfrom_records" {
  value = [for domain in aws_ses_domain_mail_from.workday : "${formatlist("%s MX 10 feedback-smtp.ap-southeast-2.amazonses.com \n%s TXT \"v=spf1 include:amazonses.com ~all\"", domain.mail_from_domain, domain.mail_from_domain)}"]
}