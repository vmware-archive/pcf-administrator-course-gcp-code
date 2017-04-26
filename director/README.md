To deploy a BOSH director:
 
* `git submodule update --init`
* create a file called `gcp_credentials.json` with the credentials of a GCP service account with "Owner" permissions
* Make sure to set the environment variables `project_id` and `env_name` are set before running `deploy.sh`

```bash
project_id=cs-twhitney env_name=twhitney-pcf ./deploy.sh
```

Once the deployment succeeds, you'll need the root CA certificate and admin password:

```bash
ruby -ryaml -e "puts YAML.load_file('creds.yml')['default_ca']['certificate']" > rootCA.pem
```

```bash
ruby -ryaml -e "puts YAML.load_file('creds.yml')['admin_password']"
```