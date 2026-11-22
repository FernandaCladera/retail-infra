# Infrastruture


Setup for the infrastructure of the Retail Simulation Project on Google Cloud.

## What it creates

```
organization                 (organization)
└── retail-sim               (folder)
    └── retail-sim-dev-fc    (project)
        ├── state bucket, APIs, budget       ← bootstrap/
        └── ecommerce: database, api, web    ← environments/dev/
```


## Folders

```
bootstrap/          Run once. Creates the folder, the project,
                    the bucket for the Terraform state and the GitHub login.

modules/            Reusable pieces. 
    cloud-run-services/     a Cloud Run service
    cloud-sql-postgres/     a Postgres database + its password

environments/dev/   Everything that lives inside the dev project.
                    One file per system (ecommerce.tf, WIP: erp.tf, pim.tf).

.github/workflows/  terraform-plan  → runs on every pull request
                    terraform-apply → runs when merged to main
```


