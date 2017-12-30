# Gitlab Role

An [Ansible](https://www.ansible.com/) role to automate the installation and
configuration of [Gitlab](https://gitlab.com/) on CentOS7.

## Requirements

None

## Variables

```yaml
gitlab_version: 10.3.2

# whether the role should prompt for a private token. Ignored when ran
# non-interactively
gitlab_prompt_for_private_token: false

gitlab_gpg_key: https://packages.gitlab.com/gpg.key
gitlab_repo_url: https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/config_file.repo?os=centos&dist=7
gitlab_api_root: api/v4
```

A private token **MUST** be defined before projects and user ssh keys will be
created/configured.

```yaml
gitlab_private_token: 'PRIVATE_TOKEN'
```

## Gitlab API and Access Tokens

Open Issue: [Ability to manage Personal Access Tokens through the API](https://gitlab.com/gitlab-org/gitlab-ce/issues/27954)

The only way to generate Personal Access Tokens is through the web UI. As such,
there is **no way** to automate the private token necessary to use the API to
create projects and configure user ssh keys.

If ran interactively, the role will prompt for a private token after a
user has been created. This can be generated manually using the web UI
and copied to the console prompt.

If ran non-interactively, the role will create the user and will not run
subsequent tasks that use the Gitlab API. The token can then be
generated, as above, before adding the token to the ansible run, i.e.

```yaml
gitlab_private_token: 'DYDhs6_xgkW9r2F8YGpV'
```

The next run of the playbook will generate any defined projects and use ssh
keys.

## Example Playbooks

```yaml
- hosts: all
  roles:
    - { role: gitlab-role, gitlab_private_token: 'DYDhs6_xgkW9r2F8YGpV' }
```

Alternatively, to interact with the play and enter the `gitlab_private_token`
at the console prompt,

```yaml
- hosts: all
  roles:
    - { role: gitlab-role, gitlab_prompt_for_private_token: true }
```

> NOTE: this will not work when ran non-interactively, for example within
> `vagrant` provisioning

## Testing

The [Vagrantfile](https://www.vagrantup.com/) can be used to provision a
default CentOS7 install using the ansible role

```console
vagrant up
# generate private_token and add to playbook.yml
vagrant provision
```

The Gitlab install is accessible at http://127.0.0.1:8000

Alternatively, you can use `vagrant` to provision the VM and `ansible` to
provision the role, with a prompt to enter the `gitlab_private_token`

```console
vagrant up --no-provision
ansible-playbook --inventory inventory \
                 --user vagrant \
                 --private-key /home/${USER}/.vagrant.d/insecure_private_key \
                 --extra-vars 'gitlab_prompt_for_private_token=true' \
                 playbook.yml
```

You will have to create an inventory file and configure [Virtualbox
Networking](https://www.vagrantup.com/docs/networking/) for a local
`ansible-playbook` to access and provision the guest VM.
