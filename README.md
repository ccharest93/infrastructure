# EKS infrastructure as code using Terragrunt/Terraform and CI/CD best practices
This is a sample of the proper way to deploy infrastructure using Terraform/Terragrunt. 
## Infrastructure module
Reusable pieces of infrastructure, the same module can be used in different projects.
- Each module in infrastructure module should have the following YAML: 0-version, 1-variables and 2-outputs. Numbering allows for consistent ordering for visibility.
- The repository should keep a list of tags that reference the versions of each module e.g "eks-self-managed-v0.0.2", the version of these tags should be incremented whenever a change is made to that modules code. (Important for the deployment side)

## Infrastructure live
Build live infrastructure using the reusable modules. The structure allows to separate dev/ prod environments into different folders. Additionally, the modules can be split into different lifecycles so they can be taken up and down at different times. As an example i have a dev environment that contains one lifecycle for my vpc and filesystem that will host a downloaded dataset ~2h to download, and one lifecycle for the eks cluster that will container the cluster for distributed training. This allows us to bring each lifecycle up and down independently.

When we use one of our module, we specify the latest tag for that module. This is both good for not breaking older use cases of the module (a project can still use an older version of the module by referring a specific version tag) and because it clearly tells terragrunt that it needs to refetch the source code when we change the version (this speeds up development and prevents nasty state lockups from inconsistencies).
