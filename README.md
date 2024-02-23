# Elastic + Kibana + Enterprise Search deployment

This repo contains a Terraform script that will deploy:

- An instance of IBM Cloud Databases for Elasticsearch Platinum
- A Code Engine Project with two applications:
    - A Kibana deployment
    - An Enterprise Search deployment

The Terraform script will ensure that all these resources can communicate with each other. It will output the public facing Kibana URL where the user can access the Enterprise Search user interface.

It will also output the URL of the Elasticsearch deployment.

## Prerequisites

- [Terraform](https://www.terraform.io/)
- [IBM Cloud CLI](https://cloud.ibm.com/docs/cli?topic=cli-getting-started)
- [An IBM Cloud Account](https://cloud.ibm.com/registration)

## Steps

### Step 1

Get an API key by following [these steps](https://cloud.ibm.com/docs/account?topic=account-userapikey&interface=ui#create_user_key).

### Step 2

Clone this repo

```sh
git clone https://github.ibm.com/Daniel-Mermelstein/elastic-kibana-ent-search.git
cd elastic-kibana-ent-search/terraform
```

### Step 3

Create a `terraform.tfvars` document with the following parameters:

```
ibmcloud_api_key = "<your api key>"
region = "<an ibm cloud region>" #e.g. eu-gb
es_url = "https://3ebddf59-57de-4f48-b6cb-d34d0d6f18e1.bmo1leol0d54tib7un7g.databases.appdomain.cloud:32041"
es_username = "admin"
es_password = "<make up a password>"
es_version="<a supported major version>" # eg 8.10
es_minor_version="a supported minor version" # e.g. 1
```

### Step 4

Run Terraform to deploy the infrastructure:

```sh
terraform init
terraform apply --auto-approve
```

The output will contain the URL of the Kibana deployment:

```
kibana_endpoint = "https://kibana-app.1dqmr45rt678g05.eu-gb.codeengine.appdomain.cloud"
```

Log in  at this URL with the username and password you supplied above.

Once logged in, you can configure Enterprise Search by visiting `https://kibana-app.1dqmr45rt678g05.eu-gb.codeengine.appdomain.cloud/app/enterprise_search/app_search/engines`

## Note about implementation

There is a circular dependency in this process because Kibana needs to know the location of the Enterprise Search deployment. But Enterprise Search also needs to know where the Kibana deployment is located. Both locations are not known until they are deployed, so Terraform is unable to configure all this in one step.

This is solved by the `kibana_app_update`null resource, which basically runs a shell script that updates the Kibana app's environment variables with the location of the Enterprise Search app after both of these have been fully deployed. This is slightly hacky but there appears to be no other way of achieving the required outcome because of the way Terraform works.

## Caveat

Currently it is impossible to know the minor version that ICD supports until the Elasticsearch instance is deployed. This is required for deploying Kibana and Enterprise Search. For the moment it is "1", but this could change. So the script may deploy Elasticsearch but then fail when trying to deploy the other resources.

You can obtain the minor version of the deployed instance by getting its URL:
```sh
terraform output es_url
# "https://admin:password@1e98bb62-2345-4126-9bbabcd2-03264897c724.c1vt02ul0q3fa0509bog.databases.appdomain.cloud:31299"
```
and then curl-ing that address:

```sh
curl -k "https://admin:password@1e98bb62-2345-4126-9bbabcd2-03264897c724.c1vt02ul0q3fa0509bog.databases.appdomain.cloud:31299"
{...
"version" : {
    "number" : "8.10.4",
    ...}
}
```

In the above example the minor version is "4". Replace the `es_minor_version` variable with that number and run the terraform script again.

(We are working on a way to avoid this in future by putting the minor version into the terraform output so that it can be used in subsequent steps)

