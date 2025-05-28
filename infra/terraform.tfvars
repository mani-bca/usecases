portfolio_name         = "S3 Portfolio"
portfolio_description  = "Portfolio for provisioning S3 buckets"
provider_name          = "maniowner"

product_name           = "S3 Bucket Product"
product_owner          = "manivasagan"
template_url           = "s3://demobucketforservicecatalog/todaydemo/bucket-old.yaml"
provisioning_name      = "v1"

enable_template_constraint = true
template_constraint_parameters = {
  Rules = {
    RegionRule = {
      Assertions = [
        {
          Assert            = "Fn::Equals([Ref(\"AWS::Region\"), \"us-west-1\"])"
          AssertDescription = "S3 buckets must be created in us-east-1"
        }
      ]
    }
  }
}

enable_launch_constraint = true
launch_role_arn          = "arn:aws:iam::676206899900:role/ServiceCatalogLaunchRole"

create_tag_option        = true
tag_key                  = "env"
tag_value                = "dev"

user_arn                 = "arn:aws:iam::676206899900:user/svc"