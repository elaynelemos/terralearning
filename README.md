# Learning Terraform

This is an unstable _Terraform_ infrastructure. Used only to keep track of what I'm learning. Structure based on cookiecutter [infra template](https://github.com/elaynelemos/terraform-template).

## Requirements

Terraform s3 state bucket has to be already created.

[GitHub Actions](./github/workflows/) requires GitHub Secrets for the project:

- `GITHUB_TOKEN` - registered token at GitHub
- `AWS_ACCESS_KEY_ID` - service user key id
- `AWS_SECRET_ACCESS_KEY` - service user access key

## Continuous Integration (currently not working)

After Push or PR to main branch GitHub Action will run [Terraform CI](./.github/workflows/ci.yml) with Linting, Init, Validate and Plan.

## Deploy

To apply the infrastructure trigger [Terraform Deploy](./.github/workflows/deploy.yml) manually at [Actions](https://github.com/elaynelemos/terraform-template/actions).


License
-------
[![License: MIT](https://badges.frapsoft.com/os/mit/mit.png?v=102)](./LICENSE)
