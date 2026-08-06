## Usage
### Please copy paste below code

```
module demo {
    source =  "ysakova90/gke/gcp
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
### Run
```
terraform init
terraform apply

```