import os
# Load model directly
from transformers import AutoTokenizer, AutoModelForSequenceClassification, pipeline

os.environ['HF_HUB_ETAG_TIMEOUT']='86400'
os.environ['HF_HUB_DOWNLOAD_TIMEOUT']='86400'
print(os.environ.get("HF_ENDPOINT"))
print(os.environ.get("HF_TOKEN"))
from huggingface_hub import snapshot_download
snapshot_download(
    repo_id="webapp/llm-brain", etag_timeout=86400, local_dir="/app/hf-storage"
)

tokenizer = AutoTokenizer.from_pretrained("/app/hf-storage")
model = AutoModelForSequenceClassification.from_pretrained("/app/hf-storage")

classifier_bert = pipeline('sentiment-analysis', model=model, tokenizer=tokenizer, device="cpu")

print(classifier_bert('The model is installed successfully !'))