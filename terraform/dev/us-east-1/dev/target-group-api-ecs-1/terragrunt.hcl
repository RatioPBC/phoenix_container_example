# Create target group for blue/green deployment

terraform {
  source = "${dirname(find_in_parent_folders())}/modules//target-group"
}
dependency "vpc" {
  config_path = "../vpc"
}
dependency "lb" {
  config_path = "../lb-public"
}
dependency "zone" {
  config_path = "../route53-public"
  # config_path = "../route53-cdn" # separate CDN domain
}
include "root" {
  path = find_in_parent_folders()
}

inputs = {
  comp = "api"
  name = "api-ecs-1"

  hosts = ["api.${dependency.zone.outputs.name_nodot}"]
  # hosts = ["${local.environment_vars.locals.dns_domain}"]

  port     = 4000
  protocol = "HTTP"

  health_check = {
    path = "/healthz"
    # interval = 30 # default 30
    # timeout = 10 # default 5
    healthy_threshold   = 2 # default 3
    unhealthy_threshold = 2 # default 3
    # matcher = "200"
    matcher = "200,302"
  }

  # stickiness = {
  #   type = "lb_cookie"
  # }

  # listener_rule = true
  listener_arn = dependency.lb.outputs.listener_arn
  vpc_id       = dependency.vpc.outputs.vpc_id
  target_type  = "ip"
}
