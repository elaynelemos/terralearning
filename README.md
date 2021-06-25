# Learning Terraform

This is an unstable _Terraform_ infrastructure. Used only to keep track of what I'm learning. Structure based on cookiecutter [infra template](https://github.com/elaynelemos/terraform-template).

### Modules structure

| #   | Name | Description | Path | Based on |
| :-- | :--- | :---------- | :--- | :------- |
| 0. | Hello World | Creating a starting EC2 instance | [hello-world](./hello-world) | [An Introduction to Terraform](https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180) |
| 1. | Autoscaling Group Example | Setting up the basics of an ASG | [asg-example](./asg-example) | [An Introduction to Terraform](https://blog.gruntwork.io/an-introduction-to-terraform-f17df9c6d180) |

### CI/CD Requirements

Terraform s3 state bucket has to be already created.

[GitHub Actions](./github/workflows/) requires GitHub Secrets for the project:

- `GITHUB_TOKEN` - registered token at GitHub
- `AWS_ACCESS_KEY_ID` - service user key id
- `AWS_SECRET_ACCESS_KEY` - service user access key

### Continuous Integration (currently not working)

After Push or PR to main branch GitHub Action will run [Terraform CI](./.github/workflows/ci.yml) with Linting, Init, Validate and Plan.

### Deploy

- **Option 1:** You can apply the infrastructure by manually triggering [Terraform Deploy](./.github/workflows/deploy.yml) at [Actions](https://github.com/elaynelemos/terraform-template/actions). (currently not working)
- **Option 2:** Or you can clone this repo and deploy it locally from your command line with terraform **from the desired infrastructure directory**:
```bash
  export AWS_ACCESS_KEY_ID='<INSERT_YOUR_KEY_HERE>'
  export AWS_SECRET_ACCESS_KEY='<INSERT_YOUR_SECRET_HERE>'
terraform init
terraform plan -out infra.tfplan
terraform apply infra.tfplan
```

Note: the commands above will, respectively, make your credentials temporarily available for scripts, initialize terraform at the project, structure the resources to be created and then create the structure itself. Use the plan command to understand what's going to be done.

### Destroy

To destroy the infrastructure created, go to its directory and run:
```bash
terraform destroy
```

License
-------
[![License: MIT](https://badges.frapsoft.com/os/mit/mit.png?v=102)](./LICENSE)
