# Use Python 3.6 as a base image
FROM python:3.6
# Copy contents into image
WORKDIR /app
COPY . .
# Install pip dependencies from requirements
RUN pip install -r requirements.txt
# Expose the correct port
EXPOSE 5500
# Create an entrypoint
ENTRYPOINT [ "python", "app.py" ]