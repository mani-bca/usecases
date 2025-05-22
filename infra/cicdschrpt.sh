#!/bin/bash

pip install -t ./package psycopg2-binary PyPDF2 nltk openai boto3

cd package
zip -r ../document_processor.zip .
cd ..
zip -g document_processor.zip processor.py

cd package
zip -r ../search_api.zip .
cd ..
zip -g search_api.zip search_api.py