# Use the specified image as the base
FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8

# Install system packages
RUN apt update && apt upgrade -y
RUN apt install -y -q build-essential python3-pip python3-dev

# Update pip and install Python packages
RUN pip3 install -U pip setuptools wheel
RUN pip3 install gunicorn uvloop httptools

# Copy requirements and install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip3 install -r /app/requirements.txt

# Copy all the code into /app directory (No volume mount needed)
COPY ./ /app

# Define environment variables for logging
ENV ACCESS_LOG=${ACCESS_LOG:-/proc/1/fd/1}
ENV ERROR_LOG=${ERROR_LOG:-/proc/1/fd/2}

# Define the Uvicorn command to run our application
CMD ["uvicorn", "main:app", "--reload", "--workers", "1", "--host", "0.0.0.0", "--port", "8000"]
