# Infrastruture

Main structure of the project

.gitignore

bootstrap/
    versions.tf
    providers.tf
    variables.tf
    main.tf             <- folder + project + APIs + Bucket del state 
    iam.tf
    outputs.tf
    terraform.tfvars

modules/
    cloud-run-service/
        main.tf
        variables.tf
        outputs.tf
    cloud-sql-postgres/
        main.tf
        variables.tf
        outputs.tf

environments/
    dev/
        versions.tf
        backends.tf
        providers.tf
        variable.tf
        shared.tf
        ecommerce.tf
        outputs.tf
        terraform.tfvars

.github/workflows/
    terraform-plan.yml
    terraform-apply.yml

