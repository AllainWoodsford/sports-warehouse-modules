variable "bucket" {
  description = "name of AWS Bucket"
  type = string
  default = "og-sports-warehouse"
}

variable "bucket_suffix" {
  description = "suffix at the end of a bucket dont include - character"
  type = string
  default = null
}

variable "encryption" {
  description = "default encryption that will be applied to the bucket"
  type = string
  #options AES256, aws:kms, aws:kms:dsse
  default = "AES256"
}