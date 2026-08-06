## Usage
### Please copy paste below code

```
module "demo" {
  source  = "ysakova90/gke/gcp"
  version = "0.0.4"

  gke_config = {
    cluster_name   = "project-cluster"
    location       = "us-west-1"
    node_count     = 1
    min_node_count = 1
    max_node_count = 2
    machine_type   = "e2-medium"
    disk_size_gb   = 100
    disk_type      = "pd-balanced"
  }
}
```

### To get output add below code
```
output cluster_location {
  description = "GKE cluster location"
  value       = google_container_cluster.primary.location
}

output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.primary.name
}
```

### Run
```
terraform init
terraform apply

```

### Outputs: 

 `cluster_name`  Name of the GKE cluster.
 `location`   Region where the GKE cluster is deployed.