FROM public.ecr.aws/lambda/python:3.9

RUN pip install boto3

COPY ./upload_handler.py ${LAMBDA_TASK_ROOT}

CMD ["upload_handler.lambda_handler"]
