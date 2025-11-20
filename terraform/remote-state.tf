data "terraform_remote_state" "tf_cognito" {
  backend = "s3"

  config = {
    bucket = "mdekort.tfstate"
    key    = "tf-cognito.tfstate"
    region = "eu-west-1"
  }
}
