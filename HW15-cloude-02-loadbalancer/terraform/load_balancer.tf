resource "yandex_lb_network_load_balancer" "lb-1" {
  name = "network-load-balancer-1"

  listener {
    name = "network-load-balancer-1-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.ig-1.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/index.html"
      }
    }
  }
}

resource "yandex_alb_target_group" "atg-1" {
  name           = "target-group1"

  target {
    subnet_id    = yandex_vpc_subnet.public.id
    ip_address   = yandex_compute_instance_group.ig-1.instances[0].network_interface[0].ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.public.id
    ip_address   = yandex_compute_instance_group.ig-1.instances[1].network_interface[0].ip_address
  }

  target {
    subnet_id    = yandex_vpc_subnet.public.id
    ip_address   = yandex_compute_instance_group.ig-1.instances[2].network_interface[0].ip_address
  }
}

resource "yandex_alb_backend_group" "backend-group1" {
  name                     = "webgroup"

  http_backend {
    name                   = "web"
    weight                 = 1
    port                   = 80
    target_group_ids       = [yandex_alb_target_group.atg-1.id]
    load_balancing_config {
      panic_threshold      = 90
    }
    healthcheck {
      timeout              = "10s"
      healthcheck_port     = "80"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15
      http_healthcheck {
        path               = "/"
      }
    }

  }
}

resource "yandex_alb_backend_group" "backend-group2" {
  name                     = "webgroup2"

  http_backend {
    name                   = "api"
    weight                 = 1
    port                   = 80
    target_group_ids       = [yandex_compute_instance_group.ig-2.application_load_balancer[0].target_group_id]
    load_balancing_config {
      panic_threshold      = 90
    }
    healthcheck {
      timeout              = "10s"
      healthcheck_port     = "80"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15
      http_healthcheck {
        path               = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "tf-router" {
  name          = "router"
  labels        = {
    tf-label    = "tf-label-value"
    empty-label = ""
  }
}

resource "yandex_alb_virtual_host" "my-virtual-host" {
  name                    = "host1"
  http_router_id          = yandex_alb_http_router.tf-router.id
  route {
    name                  = "web1"
    http_route {
      http_match {
        path {
          exact           = "/"
        }
      }
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.backend-group1.id
        timeout           = "60s"
      }
    }
  }
  route {
    name                  = "api1"
    http_route {
      http_match {
        path {
          exact           = "/"
        }
      }
      http_route_action {
        backend_group_id  = yandex_alb_backend_group.backend-group2.id
        prefix_rewrite    = "/"
        timeout           = "60s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "alb-1" {
  name        = "application-network-load-balancer-1"
  network_id  = yandex_vpc_network.my-vpc.id

  allocation_policy {
    location {
      zone_id   = var.default_zone
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "application-network-load-balancer-1-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [ 80 ]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.tf-router.id
      }
    }
  }

}





