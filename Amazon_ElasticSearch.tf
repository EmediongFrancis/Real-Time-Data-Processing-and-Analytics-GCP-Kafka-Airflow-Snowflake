resource "aws_elasticsearch_domain" "elasticsearch_domain" {
  domain_name = "madhatter-elasticsearch-domain"

  elasticsearch_version = "7.10"

  cluster_config {
    instance_type  = "m5.large.elasticsearch"
    instance_count = 2
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 20
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
  }

  tags = {
    Domain = "madhatter-elasticsearch-domain"
  }
}
