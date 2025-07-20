variable "bucket" {
  description = "name of AWS Bucket"
  type        = string
  default     = "og-sports-warehouse"
}

variable "bucket_suffix" {
  description = "suffix at the end of a bucket dont include - character"
  type        = string
  default     = null
}

variable "encryption" {
  description = "default encryption that will be applied to the bucket"
  type        = string
  #options AES256, aws:kms, aws:kms:dsse
  default = "AES256"
}

variable "user_arn" {
  description = "full ARN as string i.e.arn:aws:iam::<ID>:user/terraform-user"
  type        = string
  default     = ""
}

variable "lock_file_path" {
  description = "does not need starting / character i.e. state/terraform.tfstate.tflock"
  type        = string
  default     = ""
}