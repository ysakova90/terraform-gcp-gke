resource "google_project_service" "apis" {
  for_each           = toset(local.gcp_services)
  service            = each.value
  disable_on_destroy = false
}

# Creates a cluster
resource "google_container_cluster" "primary" {
  deletion_protection      = false
  depends_on               = [google_project_service.apis]
  name                     = var.gke_config["cluster_name"]
  location                 = var.gke_config["location"]
  remove_default_node_pool = true
  initial_node_count       = 1
  cluster_autoscaling {
    enabled             = false
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  logging_config {
    enable_components = []
  }
  monitoring_config {
    enable_components = []
    managed_prometheus {
      enabled = false
    }
  }
}

# Creates a node pool
resource "google_container_node_pool" "primary_nodes" {
  name     = "project-node-pool"
  location = var.gke_config["location"]
  cluster  = google_container_cluster.primary.name

  initial_node_count = var.gke_config["node_count"]

  node_locations = length(var.node_locations) > 0 ? var.node_locations : null

  autoscaling {
    total_min_node_count = var.gke_config["min_node_count"]
    total_max_node_count = var.gke_config["max_node_count"]
    location_policy      = "ANY"
  }

  node_config {
    machine_type = var.gke_config["machine_type"]
    disk_size_gb = var.gke_config["disk_size_gb"]
    disk_type    = var.gke_config["disk_type"]
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count, autoscaling[0].total_min_node_count]
  }
}

# Optional local kubeconfig setup for users running Terraform from their own machine.
resource "null_resource" "set_kubeconfig" {
  depends_on = [
    google_container_cluster.primary,
  ]

  triggers = {
    cluster_id = google_container_cluster.primary.id
    project_id = data.google_client_config.current.project
    location   = var.gke_config["location"]
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.gke_config["cluster_name"]} --location ${var.gke_config["location"]} --project ${data.google_client_config.current.project}"
  }
}

