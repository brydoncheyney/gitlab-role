# Gitlab Role

An [Ansible](https://www.ansible.com/) role to automate the installation and
configuration of [Gitlab](https://gitlab.com/) on CentOS6/7.

## Requirements

None

## Variables

```yaml
gitlab_version: 10.3.2

gitlab_gpg_key: https://packages.gitlab.com/gpg.key
gitlab_repo_url: https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/config_file.repo?os=centos&dist=7
gitlab_api_root: api/v4
```

## Gitlab API and Access Tokens

Open Issue: [Ability to manage Personal Access Tokens through the API](https://gitlab.com/gitlab-org/gitlab-ce/issues/27954)

~~The only way to generate Personal Access Tokens is through the web UI. As such, there is **no way** to automate the private token necessary to use the API to create projects and configure user ssh keys.~~

Ok, thanks to a comment from [Elvis Stansvik](https://gitlab.com/elvstone)
`gitlab-rails runner` can be used to generate a private token that can be used
to automate calls to the Gitlab API. The role will revoke this private token at
the end of the role play.

> Note that his token is set to revoke after a day, should the playbook fail
> before this task is ran.

Of course, relying on `gitlab-rails runner` is **SLOW**....

## Example Playbooks

```yaml
- hosts: all
  roles:
    - { role: gitlab-role }
```

## Testing

The [Vagrantfile](https://www.vagrantup.com/) can be used to provision a
default CentOS7 install using the ansible role

```console
vagrant up
```

The Gitlab install is accessible at http://127.0.0.1:8000

Alternatively, you can use `vagrant` to provision the VM and `ansible` to
provision the role

```console
vagrant up --no-provision
ansible-playbook --inventory inventory \
                 --user vagrant \
                 --private-key /home/${USER}/.vagrant.d/insecure_private_key \
                 playbook.yml
```

You will have to create an inventory file and configure [Virtualbox
Networking](https://www.vagrantup.com/docs/networking/) for a local
`ansible-playbook` to access and provision the guest VM...
