FROM python:3.12-slim

WORKDIR /src

# Copy project files
COPY src .
COPY requirements.txt .

# Install dependencies
RUN pip install -r requirements.txt

# Expose app's port
EXPOSE 8080

# Run the FastAPI application using uvicorn server
CMD ["uvicorn", "presentation.rest.main:app", "--host", "0.0.0.0", "--port", "8080"]
