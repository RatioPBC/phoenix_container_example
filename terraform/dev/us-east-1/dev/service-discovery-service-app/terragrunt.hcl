# Create Service Discovery Service

terraform {
  source = "${dirname(find_in_parent_folders())}/modules//service-discovery-service"
}
dependency "namespace" {
  config_path = "../service-discovery-namespace"
}
include "root" {
  path = find_in_parent_folders()
}

inputs = {
  comp    = "app"
  namespace_id = dependency.namespace.outputs.id
  routing_policy = "MULTIVALUE"
}
