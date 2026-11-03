# Goals/Intent:
The scope and vision of this project/repo is to have a single source of truth of defined machines to be automatically provisioned for the tasks they are responsible based on that inventory file.

For example:
A machine is defined in `inventory.yaml` under the group of `cloud`. When the `ansible-pull` command is ran on that machine and its hostname matches what is in the inventory, it will provision itself accordingly as defined in `roles/<role>/`.

>==NOT TESTED==\
If the machine is not a part of any role the repo recognizes, a baseline `roles/common/` is still ran that does some smaller things like housekeeping and installing a monitoring agent.

## Usage:
~~Be sure to read any `roles/<role>/vars/*` to get an idea of anything you may want changed.~~

Vars are mostly centralized in the `inventory.yaml` and should be changed there. There may be a `roles/<role>/vars/main.yaml` (which could also be a vault) that would need manual editing if changes are desired.

The `tasks/entrypoint.yaml` is a frontend task to install Caddy with a Caddyfile. The Caddyfile templates `${base_domain}` but the backends that it reverse proxies to are static. I believe this is acceptable because `ansible-pull` is periodically pulled to always be in line with the intent of this repo. 

1. Edit the `inventory.yaml` to describe your machine that will be created and commit back to repo
2. This repo statically sets the `base_domain` and `ansible_pull_url` in `vars/main.yaml`
    > These can be changed in the repo or by defining them when running `ansible-pull --only-if-changed --ask-vault-pass --url https://git.cafio.co/casey/puller.git --extra-vars base_domain=foo,ansible_pull_url=bar --tags (if any desired) --skip-tags (if any desired)` 
3. Profit?

## Developing:
### New Capabilities:
Decide if it is something that should be a new role (something a dedicated server would be likely to handle in its entirety) or if its a simple one-off that could be tacked on to another server
- New roles should be added to `roles/<role_name>` with a consistent structure as the other roles
- Single tasks should be add to `roles/common/tasks/<task_name>.yaml` or within a more appropriate/new role

If it takes more than a handful of tasks and involves copying files or templates, it should probably be a role

### Updating Variables:
Roles have their own `roles/<role>/vars/` for secrets and variables that are used in that role. Ideally, it would just be those variables that are updated and not within `roles/<role>/tasks/`.

An example of this being used may be a container image tag that you wouldn't want set to `:latest`