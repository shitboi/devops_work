resource "aws_dynamodb_table" "project_sapphire_inventory" {
  name           = "inventory"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "AssetID"

  attribute {
    name = "AssetID"
    type = "N"
  }
  attribute {
    name = "AssetName"
    type = "S"
  }
  attribute {
    name = "age"
    type = "N"
  }
  attribute {
    name = "Hardware"
    type = "B"
  }
  global_secondary_index {
    name             = "AssetName"
    hash_key         = "AssetName"
    projection_type    = "ALL"
    
  }
  global_secondary_index {
    name             = "age"
    hash_key         = "age"
    projection_type    = "ALL"
    
  }
  global_secondary_index {
    name             = "Hardware"
    hash_key         = "Hardware"
    projection_type    = "ALL"
    
  }
}
resource "aws_dynamodb_table_item" "upload" {
  table_name = aws_dynamodb_table.project_sapphire_inventory.name
  hash_key = aws_dynamodb_table.project_sapphire_inventory.hash_key
  item = <<EOF
  {
    "AssetID": {"N": "1"},
    "AssetName": {"S": "printer"},
    "age": {"N": "5"},
    "Hardware": {"B": "true" }
  }
  EOF
}

#terraform remote
resource "local_file" "state" {
    filename = "/root/${var.local-state}"
    content = "This configuration uses ${var.local-state} state" 
}

terraform {
  backend "s3" {
    key = "terraform.tfstate"      #*
    region = "us-east-1"      #*
    bucket = "remote-state"      #*
    endpoint = "http://172.16.238.105:9000"      #optional
    force_path_style = true      #optional
  }