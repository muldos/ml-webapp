#MLOps demo web application

[![Last build](https://github.com/muldos/ml-webapp/actions/workflows/workflow.yaml)]

From scratch 

`pip install flask 'transformers[torch]'`

How to build locally 

Export required env vars
```
export HF_TOKEN=
export HF_ENDPOINT
```

Build the image

```
docker build --build-arg \ 
   --build-arg jf_url=https://myjpd.kfrog.io \
   --build-arg pypi_remote_repo=my-pypi-remote
   --secret "id=pip-index-url,src=$PWD/pip-creds.txt" \ 
   --secret id=HF_TOKEN --secret id=HF_ENDPOINT \ 
   -t mlapps:1.0.0 .
```