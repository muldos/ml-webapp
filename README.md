From scratch 

`pip install flask 'transformers[torch]'`

```
export HF_TOKEN=
export HF_ENDPOINT
docker build --secret "id=pip-index-url,src=$PWD/pip-creds.txt" --secret id=HF_TOKEN --secret id=HF_ENDPOINT -t mlapps:1.0.0 .
```