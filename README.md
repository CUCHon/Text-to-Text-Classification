
## 1. Motivation

This repository contains the experimental code for Text-to-Text Classifier.

Text classification was conventionally handled by supervised classifiers which treat labels as a set of indices. Recently, the NLP community increasingly treats all NLP tasks as a text-2-text generation paradigm. Although this seems a natural choice for text generation task, but if it really fit text classification tasks? Will it decrease or increase the text classification performance? 

We tend to systematically study this research question by conducting experiments on various popular classification datasets. 

## 2. Environment

- Python 3.8
- PyTorch 2.0.0
- CUDA 11.7
- Transformers 4.27.4

Prepare the anaconda environment:

```bash
conda create -n t2t python=3.8.0
conda activate t2t
pip install -r requirements.txt
```


## 3. News

- 04/10/2023: Add code for Indent Indentification task. The dataset *banking_data* is from [here](https://github.com/PolyAI-LDN/task-specific-datasets/tree/master/banking_data). See the [README]() for more details.